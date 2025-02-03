/* Without this record the redirect won't work since traffic won't gor through CF proxy */
resource "cloudflare_record" "redirect" {
  for_each = { for e in var.redirects: "${e.name}.${e.domain}" => e }
  zone_id  = lookup(var.zones, each.value.domain)
  name     = each.value.name
  value    = var.target
  type     = "CNAME"
  ttl      = 1
  proxied  = true
}

resource "cloudflare_page_rule" "redirect" {
  for_each = { for e in var.redirects: "${e.name}.${e.domain}" => e }
  zone_id  = lookup(var.zones, each.value.domain)
  target   = join("", [
    each.value.name == "@" ? "" : "${each.value.name}.",
    each.value.domain,
    lookup(each.value, "path", var.default_path),
  ])

  actions {
    forwarding_url {
      url         = each.value.url
      status_code = each.value.status_code
    }
  }

  lifecycle {
    /* Priority cannot be easily managed via Terraform:
     * https://github.com/terraform-providers/terraform-provider-cloudflare/issues/187 */
    ignore_changes = [ priority ]
  }
}


# HTTPS enforcement rules, they are a way to skip redirect for subpaths of
# the path we want to redirect - they have higher priority
# https://community.cloudflare.com/t/how-to-exclude-part-of-redirects-from-page-rules/433739/2
resource "cloudflare_page_rule" "redirect_excluded" {
  for_each = { for r in var.redirects_exclusions : "${r.name}.${r.domain}/${r.path}" => r }
  zone_id = lookup(var.zones, each.value.domain)
  target   = join("", [
    "https://",
    each.value.name == "@" ? "" : "${each.value.name}.",
    each.value.domain,
    each.value.path,
  ])
  priority = 2
  actions {
    always_use_https = true
  }
}

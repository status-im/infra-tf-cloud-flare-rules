# Description

This [Terraform](https://www.terraform.io/docs/index.html) module configures CloudFlare [Page Rules](https://www.cloudflare.com/features-page-rules/).

# Usage

To use this you have to supply 3 variables:

* `zones` - Map of CloudFlare zone names to IDs.
* `target` - Domain to point at for domains we are redirecting.
* `redirects` - List of redirects to create.

Keep in mind that `target` is just a "dummy" and should not be used, unless the matching redirect doesn't exist.

# Example

Here's an example of how you can configure it:
```terraform
module "redirect" {
  source    = "modules/cloud-flare-rules"
  zones     = local.zones
  target    = "invalid-domain.status.im"
  redirects = [
    {
      zone   = "status.im"
      domain = "token"
      path   = "/*"
      url    = "https://coinmarketcap.com/currencies/status/"
    },
    {
      zone   = "status.im"
      domain = "banana"
      path   = "/*"
      url    = "https://en.wikipedia.org/wiki/Banana"
    },
  ]
}
```

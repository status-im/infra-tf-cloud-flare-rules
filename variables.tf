variable "zones" {
  description = "Map of CloudFlare zone names to IDs"
  type        = map(string)
}

variable "target" {
  description = "Domain to point at for domains we are redirecting."
  type        = string
  default     = "invalid-domain.status.im"
}

variable "default_path" {
  description = "Domain to point at for domains we are redirecting."
  type        = string
  default     = "/*"
}

variable "redirects" {
  description = "List of redirect entries to create as page rules."
  type        = list(object({
    domain = string
    name   = string
    url    = string
    status_code = number
    /* path = string */
  }))
  default     = []
}

variable "redirects_exclusions" {
  description = "A list of exclusions for the redirects with details such as name, domain, and path."
  type        = list(object({
    name   = string
    domain = string
    path   = string
  }))
  default     = []
}
variable "purpleteamlabs_cloudflare_dns_zone_id" { type = string }

variable "name" { 
  description = "The left side of the record."
  type = string
}
variable "content" {
  description = "The right side of the record."
  type = string
}

variable "type" {
  type = string
  default = "CNAME"
}
variable "proxied" {
  type = bool
  default = false
}


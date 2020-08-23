variable "purpleteamlabs_cloudflare_dns_zone_id" { type = string }
variable "name_and_content_keyed_by_sut" { 
  type = map(object({
    name = string
    content = string
  }))
}
variable "type" {
  type = string
  default = "CNAME"
}
variable "proxied" {
  type = bool
  default = false  
}

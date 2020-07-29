variable "purpleteamlabs_cloudflare_dns_zone_id" { type = string }
variable "purpleteamlabs_domain_name" { type = string }
variable "invoking_root" { type = string }
variable "suts_attributes" {
  description = "The attributes that apply to each specific SUT."  
  type = map(object({
    purpleteamlabs_sut_cname = string
  }))
}

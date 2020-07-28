variable "vpc_id" {}
variable "default_network_acl_id_of_default_vpc" {}
variable "default_network_acl_id_of_main_vpc" {}
variable "pt_nACL" {
  description = "Rules that will not change often."
  type = object({
    inbound_rules = list(any)
    outbound_rules = list(any)
  })
}
variable "public_and_2nd_mandatory_subnet_for_lb_subnet_ids" { type = list(string) }

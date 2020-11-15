variable "nlb_name" {
  type = string
}
variable "vpc_id" {
  type = string
}
variable "region" {
  type = string
}

variable "profile" {
  type = string
}

data "external" "get_nlb_ips" {
  program = ["python", "${path.module}/getNlbPrivateIps.py"]
  query = {
    aws_nlb_name  = var.nlb_name
    aws_vpc_id    = var.vpc_id
    aws_region    = var.region
    aws_profile   = var.profile
  }
}

locals {
  aws_nlb_network_interface_ips = flatten([jsondecode(data.external.get_nlb_ips.result.private_ips)])
  aws_nlb_network_interface_cidr_blocks = [ for ip in local.aws_nlb_network_interface_ips : "${ip}/32" ]
}

output "aws_nlb_ips" {
  value = local.aws_nlb_network_interface_cidr_blocks
}

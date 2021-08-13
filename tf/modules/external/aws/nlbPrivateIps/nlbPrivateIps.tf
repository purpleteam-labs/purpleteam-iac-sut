// Copyright (C) 2017-2021 BinaryMist Limited. All rights reserved.

// This file is part of PurpleTeam.

// PurpleTeam is free software: you can redistribute it and/or modify
// it under the terms of the MIT License.

// PurpleTeam is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// MIT License for more details.

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
  program = ["python3", "${path.module}/getNlbPrivateIps.py"]
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

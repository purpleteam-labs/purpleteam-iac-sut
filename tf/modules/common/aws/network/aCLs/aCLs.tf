// Copyright (C) 2017-2021 BinaryMist Limited. All rights reserved.

// This file is part of purpleteam.

// purpleteam is free software: you can redistribute it and/or modify
// it under the terms of the MIT License.

// purpleteam is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// MIT License for more details.

// Adopt defaults

resource "aws_default_network_acl" "default" {  
  default_network_acl_id = var.default_network_acl_id_of_default_vpc

  # no rules defined, deny all traffic in this ACL

  // https://github.com/hashicorp/terraform/issues/9824
  // https://www.terraform.io/docs/configuration/resources.html#ignore_changes
  lifecycle {
    ignore_changes = [subnet_ids]
  }
}

resource "aws_default_network_acl" "main" {  
  default_network_acl_id = var.default_network_acl_id_of_main_vpc

  # no rules defined, deny all traffic in this ACL

  // https://github.com/hashicorp/terraform/issues/9824
  // https://www.terraform.io/docs/configuration/resources.html#ignore_changes
  lifecycle {
    ignore_changes = [subnet_ids]
  }
}

// Set-up pt NACL

resource "aws_network_acl" "sut_nacl" {

  vpc_id = var.vpc_id
  subnet_ids = var.public_and_2nd_mandatory_subnet_for_lb_subnet_ids

  // Static ingress rules
  dynamic "ingress" {
    for_each = var.sut_nACL.inbound_rules
    content {
      protocol = ingress.value.protocol
      rule_no = ingress.value.rule_no
      action = ingress.value.action
      cidr_block = ingress.value.cidr_block
      from_port = ingress.value.from_port
      to_port = ingress.value.to_port
      icmp_type = ingress.value.icmp_type
    }
  }

  // Static egress rules
  dynamic "egress" {
    for_each = var.sut_nACL.outbound_rules
    content {
      // https://www.terraform.io/docs/configuration/expressions.html#null
      protocol = egress.value.protocol
      rule_no = egress.value.rule_no
      action = egress.value.action
      cidr_block = egress.value.cidr_block
      from_port = egress.value.from_port
      to_port = egress.value.to_port
      icmp_type = egress.value.icmp_type
    }
  }

  tags = {
    Name = "sut_nacl",
    source = "iac-nw-aCLs"
  }
}

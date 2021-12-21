// Copyright (C) 2017-2022 BinaryMist Limited. All rights reserved.

// This file is ancillary to PurpleTeam.

// purpleteam-iac-sut is free software: you can redistribute it and/or modify
// it under the terms of the MIT License.

// purpleteam-iac-sut is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// MIT License for more details.

// Security Groups for ECS instances.
output "sg_ssh_id" {
  value = module.securityGroups.sg_ssh_id
  sensitive = true
}

output "sg_sut_id" {
  value = module.securityGroups.sg_sut_id
  sensitive = true
}

// Subnet Ids
# output "public_and_2nd_mandatory_subnet_for_lb_subnet_ids" {
#   value = local.public_and_2nd_mandatory_subnet_for_alb_subnet_ids
#   sensitive = true
# }

// The "public" subnet Id
output "public_subnet_ids" {
  value = local.public_subnet_ids
  sensitive = true
}

// VPC Id
output "vpc_id" {
  value = module.vpc.vpc_id
  sensitive = true
}

output "aws_lb_target_groups" {
  value = module.loadBalancer.aws_lb_target_groups
  description = "The SUT specific lb target groups."
  sensitive = true
}

output "aws_lb_name" {
  value = module.loadBalancer.aws_lb_name
  sensitive = true
}

output "aws_lb_arn" {
  value = module.loadBalancer.aws_lb_arn
  sensitive = true
}

output "aws_lb_dns_name" {
  value = module.loadBalancer.aws_lb_dns_name
  sensitive = true
}

// Following is for debugging
# output "region" {
#   value = var.AWS_REGION
# }
# output "aws_nlb_ips" {
#   value = module.nlbPrivateIps.aws_nlb_ips
# }

output "api_cert_arn" {
  value = module.certificateManagerGlobalAPI.aws_acm_certificate.arn
  sensitive = true
}

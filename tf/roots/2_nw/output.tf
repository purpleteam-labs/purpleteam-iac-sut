// Security Groups for ECS instances.
output "sg_ssh_id" {
  value = module.securityGroups.sg_ssh_id
  sensitive = true
}

output "sg_pt_id" {
  value = module.securityGroups.sg_pt_id
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

output "api_cert_arns" {
  value = {for k, v in var.suts_attributes : k => module.certificateManagerGlobalAPI.aws_acm_certificates[k].arn}
  sensitive = true
}

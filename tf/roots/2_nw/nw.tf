locals {
  vpc_tags = { Name = "pt-vpc-${var.AWS_REGION}", source = "iac-nw" }
  igw_tags = { Name = "pt-igw-${var.AWS_REGION}", source = "iac-nw" }
  subnets_properties = [
    {
      name = "public",
      cidr = "10.0.0.0/17",
      availability_zone = "${var.AWS_REGION}a"
    }, {
      name = "2nd-mandatory-subnet-for-LB"
      cidr = "10.0.128.0/17",
      availability_zone = "${var.AWS_REGION}b"
    }
  ]
  public_and_2nd_mandatory_subnet_for_lb_subnet_ids = [
    for subnet in module.subnets.pub_subnets:
    subnet.id
  ]
  public_subnet_ids = [
    for subnet in module.subnets.pub_subnets:
    subnet.id if lookup(subnet.tags, "Name") == "public"
  ]
}

module "vpc" {
  source = "../../modules/common/aws/network/vpc"
  cidr = var.vpc_cidr
  vpc_tags = local.vpc_tags
}

module "subnets" {
  source = "../../modules/common/aws/network/subnets"
  vpc_id = module.vpc.vpc_id
  subnets_properties = local.subnets_properties
}

module "loadBalancer" {
  source = "../../modules/common/aws/compute/ec2/nlb"  
  public_subnet_ids = local.public_subnet_ids
  vpc_id = module.vpc.vpc_id
  suts_attributes = var.suts_attributes
}

// The NLB private IP address is not available via the aws_lb resource until it's been implemented.
//   Details of PR and work-around here: https://github.com/terraform-providers/terraform-provider-aws/pull/2901
//   Details of PR and what looks like about to be merged (2020-07): https://github.com/terraform-providers/terraform-provider-aws/pull/11404
module "nlbPrivateIps" {
  source = "../../modules/external/aws/nlbPrivateIps"
  nlb_name = module.loadBalancer.aws_lb_name
  vpc_id = module.vpc.vpc_id
  region = var.AWS_REGION
  profile = var.AWS_PROFILE
}

module "securityGroups" {
  source = "../../modules/common/aws/network/securityGroups"
  vpc_id_default = module.vpc.vpc_id_default
  vpc_id = module.vpc.vpc_id
  admin_source_ips = var.admin_source_ips
  non_default_vpc_name = local.vpc_tags.Name
  aws_nlb_ips = module.nlbPrivateIps.aws_nlb_ips
}

module "NACLs" {
  source = "../../modules/common/aws/network/aCLs"
  vpc_id = module.vpc.vpc_id
  default_network_acl_id_of_default_vpc = module.vpc.default_network_acl_id_of_default_vpc
  default_network_acl_id_of_main_vpc = module.vpc.default_network_acl_id_of_main_vpc
  pt_nACL = var.pt_nACL
  public_and_2nd_mandatory_subnet_for_lb_subnet_ids = local.public_and_2nd_mandatory_subnet_for_lb_subnet_ids
}

// Forget about the default igw, we can't modify it. Just create a new one
// Currently this just creates the Sydney gateway for the Sydney VPC
module "internetGateways" {
  source = "../../modules/common/aws/network/internetGateways"
  vpc_id = module.vpc.vpc_id
  igw_tags = local.igw_tags
}

locals {
  vpc_tags = { Name = "pt-vpc-${var.AWS_REGION}", source = "iac-nw" }
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
  public_and_2nd_mandatory_subnet_for_alb_subnet_ids = [
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
  cidr = "${var.vpc_cidr}"
  vpc_tags = "${local.vpc_tags}"
}

module "subnets" {
  source = "../../modules/common/aws/network/subnets"
  vpc_id = "${module.vpc.vpc_id}"
  subnets_properties = local.subnets_properties
}

module "loadBalancer" {
  source = "../../modules/common/aws/compute/ec2/nlb"  
  public_subnet_ids = local.public_subnet_ids
  vpc_id = module.vpc.vpc_id
  suts_attributes = var.suts_attributes
}

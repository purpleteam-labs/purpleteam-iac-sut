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

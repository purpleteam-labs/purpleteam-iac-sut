locals {
  vpc_tags = { Name = "pt-vpc-${var.AWS_REGION}", source = "iac-nw" }

}

module "vpc" {
  source = "../../modules/common/aws/network/vpc"
  cidr = "${var.vpc_cidr}"
  vpc_tags = "${local.vpc_tags}"
}

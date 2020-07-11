variable "aws_region" {
  description = "AWS region in use."
  type = string
}

variable "aws_profile" {
  description = "AWS profile to run commands as."
  type = string
}

provider "aws" {
  profile = var.aws_profile
  # Bug: region shouldn't be required but is: https://github.com/terraform-providers/terraform-provider-aws/issues/7750
  region = var.aws_region
}


variable "AWS_REGION" {
  description = "AWS region in use."
  type = string
}
variable "AWS_PROFILE" {
  description = "AWS profile to run commands as."
  type = string
}
provider "aws" {
  profile = var.AWS_PROFILE
  # Bug: region shouldn't be required but is: https://github.com/terraform-providers/terraform-provider-aws/issues/7750
  region = var.AWS_REGION
}

// Issue around removing tf warnings for undeclared variables: https://github.com/hashicorp/terraform/issues/22004
variable "AWS_ACCOUNT_ID" { description = "Not used. Is here to stop Terraform warnings." }

variable "cloudflare_account_id" { description = "Not used. Is here to stop Terraform warnings." }
variable "cloudflare_api_token" { description = "Not used. Is here to stop Terraform warnings." }

// Consume nw outputs.
variable "aws_lb_target_groups" {
  description = "Used in creation of ECS Service, and Autoscaling Group."
  type = string
}


variable "ssm_parameters" {
  description = "Systems Manager Parameters."
  type = map(object({
    type = string
    value = string
    description = string
    tags = map(string)
  }))
}

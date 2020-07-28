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

variable "cloudflare_account_id" {
  description = "Used in cloudflare provider."
  type = string
}
variable "cloudflare_api_token" {
  description = "Used in cloudflare provider."
  type = string
}
provider "cloudflare" {
  account_id = var.cloudflare_account_id
  api_token = var.cloudflare_api_token
}




variable "vpc_cidr" {
  type = string
}

variable "suts_attributes" {
  description = "The attributes that apply to each specific SUT."  
  type = map(object({
    // Populate with properties as required
    pt_lb_listener_port = number
  }))
}

variable "admin_source_ips" {
  description = "The source IPs of our admins."
  type = map(object({
    description = string
    source_ips = list(string)
  }))  
}

variable "pt_nACL" {
  description = "Rules that will not change often."
  type = object({
    inbound_rules = list(object({
      protocol   = string
      rule_no    = number
      action     = string
      cidr_block = string
      from_port  = number
      to_port    = number
      icmp_type  = number
    }))
    outbound_rules = list(object({
      protocol   = string
      rule_no    = number
      action     = string
      cidr_block = string
      from_port  = number
      to_port    = number
      icmp_type  = number
    }))
  })
}

// Copyright (C) 2017-2022 BinaryMist Limited. All rights reserved.

// This file is ancillary to PurpleTeam.

// purpleteam-iac-sut is free software: you can redistribute it and/or modify
// it under the terms of the MIT License.

// purpleteam-iac-sut is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// MIT License for more details.

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
// Used for certificateManagerGlobal.
provider "aws" {
  profile = var.AWS_PROFILE
  region = "us-east-1"
  alias = "us_east_1"
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

variable "purpleteamlabs_cloudflare_dns_zone_id" {
  description = "Used for TLS cert validation for API Gateway."
  type = string
}

variable "purpleteamlabs_domain_name" {
  description = "Used for API Gateway cert creation."
  type = string
}
variable "purpleteamlabs_sut_cname" {
  description = "Used for API Gateway cert creation."
  type = string
}

variable "gitlab_pages_ip_address" {
  description = "... in domainNames.tf requires the auth subdomain to be a valid A record, any content will do, so we just use gitlab pages."
  type = string
  default = "35.185.44.232"
}

variable "vpc_cidr" {
  type = string
}

variable "suts_attributes" {
  description = "The attributes that apply to each specific SUT."  
  type = map(object({
    // Populate with properties as required
    sut_lb_listener_port = number
    container_port = number
    name = string
  }))
}

variable "admin_source_ips" {
  description = "The source IPs of our admins."
  type = map(object({
    description = string
    source_ips = list(string)
  }))  
}

variable "sut_nACL" {
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

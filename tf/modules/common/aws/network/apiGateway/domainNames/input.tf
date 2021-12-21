// Copyright (C) 2017-2022 BinaryMist Limited. All rights reserved.

// This file is ancillary to PurpleTeam.

// purpleteam-iac-sut is free software: you can redistribute it and/or modify
// it under the terms of the MIT License.

// purpleteam-iac-sut is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// MIT License for more details.

variable "api_cert_arn" { type = string }
variable "purpleteamlabs_domain_name" { type = string }
variable "purpleteamlabs_sut_cname" { type = string }
variable "purpleteamlabs_cloudflare_dns_zone_id" { type = string }

// To specify dependency due to API Gateway's flaws.
variable "stages" {
  type = list(map(any))
}
variable "aws_api_gateway_rest_api_suts" { 
  description = "The REST APIs for each SUT"
  type = map(object({
    id: string
  }))
}
variable "stage_values" {
  description = "See top level module for definition."
}
variable "suts_attributes" {
  description = "The attributes that apply to each specific SUT."
  type = map(object({
    // Populate with properties as required
    name: string
  }))
}

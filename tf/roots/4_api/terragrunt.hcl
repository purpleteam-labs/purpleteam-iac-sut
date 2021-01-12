// Copyright (C) 2017-2021 BinaryMist Limited. All rights reserved.

// This file is part of purpleteam.

// purpleteam is free software: you can redistribute it and/or modify
// it under the terms of the MIT License.

// purpleteam is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// MIT License for more details.

// Doc: [Configuration Parsing Order](https://terragrunt.gruntwork.io/docs/getting-started/configuration/#configuration-parsing-order)

include {
  path = find_in_parent_folders()
}

locals {
  common_vars = yamldecode(file("${find_in_parent_folders("common_vars.yaml")}"))
  // More locals here ...
}

dependency "static" {
  config_path = "../1_static"
}

dependency "nw" {
  config_path = "../2_nw"
}

inputs = {
  // Consume static outputs
  api_gateway_cloudwatch_role = dependency.static.outputs.api_gateway_cloudwatch_role

  // Consume nw outputs
  aws_lb_name = dependency.nw.outputs.aws_lb_name
  aws_lb_arn = dependency.nw.outputs.aws_lb_arn
  aws_lb_dns_name = dependency.nw.outputs.aws_lb_dns_name
  api_cert_arn = dependency.nw.outputs.api_cert_arn

  suts_attributes = local.common_vars.suts_attributes
}


terraform {
  // https://github.com/terraform-providers/terraform-provider-aws/issues/3174#issuecomment-383718440
  extra_arguments "concurrency_issues_in_api_gateway" {
    commands = ["apply", "destroy"]
    arguments = ["-parallelism=5"]
  }
}


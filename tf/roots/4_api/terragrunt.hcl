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


// Doc: [Configuration Parsing Order](https://terragrunt.gruntwork.io/docs/getting-started/configuration/#configuration-parsing-order)

include {
  path = find_in_parent_folders()
}

locals {
  common_vars = yamldecode(file("${get_terragrunt_dir()}/${find_in_parent_folders("common_vars.yaml")}"))
  // More locals here ...
}



inputs = {

}


terraform {
  // https://github.com/terraform-providers/terraform-provider-aws/issues/3174#issuecomment-383718440
  extra_arguments "concurrency_issues_in_api_gateway" {
    commands = ["apply", "destroy"]
    arguments = ["-parallelism=5"]
  }
}


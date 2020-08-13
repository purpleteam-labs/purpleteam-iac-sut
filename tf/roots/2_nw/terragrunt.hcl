// Doc: [Configuration Parsing Order](https://terragrunt.gruntwork.io/docs/getting-started/configuration/#configuration-parsing-order)

include {
  path = find_in_parent_folders()
}

locals {
  common_vars = yamldecode(file("${get_terragrunt_dir()}/${find_in_parent_folders("common_vars.yaml")}"))
  // More locals here ...
}

inputs = {
  suts_attributes = local.common_vars.suts_attributes

}

terraform {
  
}


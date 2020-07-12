// Doc: https://terragrunt.gruntwork.io/docs/features/locals/

locals {
  common_vars = <source of your common vars>
  // ...
}

terraform {
  extra_arguments "secrets" {
    commands = get_terraform_commands_that_need_vars()
    arguments = [
      "<location of your secrets>"
    ]
  }

  // ...
}

inputs = {
  aws_region = "${local.common_vars.aws_region}"
  aws_profile = "${local.common_vars.aws_profile}"

  // ...
}

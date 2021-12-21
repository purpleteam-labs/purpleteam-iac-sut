// Copyright (C) 2017-2022 BinaryMist Limited. All rights reserved.

// This file is ancillary to PurpleTeam.

// purpleteam-iac-sut is free software: you can redistribute it and/or modify
// it under the terms of the MIT License.

// purpleteam-iac-sut is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// MIT License for more details.

// Doc: https://terragrunt.gruntwork.io/docs/features/locals/

locals {
  common_vars = <source of your common vars>
  // ...
  users_dot_terraformrc_path = "${local.user_home_dir}/.terraformrc"
}

terraform {
  extra_arguments "secrets" {
    commands = get_terraform_commands_that_need_vars()
    arguments = [
      "<location of your secrets>"
    ]
  }

  extra_arguments "custom_env_vars_from_file" {
    commands = get_terraform_commands_that_need_vars()
    arguments = [
      "-var-file=${get_terragrunt_dir()}/${find_in_parent_folders(".env")}"
    ]
  }

  // ...

  before_hook "chmod_dot_terraformrc" {
    commands = ["init"]
    execute = ["chmod", "600", "${local.users_dot_terraformrc_path}"]
    run_on_error = true
  }
}

inputs = {
  purpleteamlabs_cloudflare_dns_zone_id = "<your-cloudflarea-dns-zone-id>"
  purpleteamlabs_domain_name = "<your-domain-name.com>"
  purpleteamlabs_sut_cname = "sut"
}

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
  ecs_instance_profile = dependency.static.outputs.ecs_instance_profile
  ecs_service_role = dependency.static.outputs.ecs_service_role
  ecs_task_execution_role = dependency.static.outputs.ecs_task_execution_role

  // Consume nw outputs
  sg_sut_id = dependency.nw.outputs.sg_sut_id
  sg_ssh_id = dependency.nw.outputs.sg_ssh_id
  vpc_id = dependency.nw.outputs.vpc_id
  aws_lb_target_groups = dependency.nw.outputs.aws_lb_target_groups
  public_subnet_ids = dependency.nw.outputs.public_subnet_ids
  // Take public_subnet_ids from the output of the nw root (Ex: ["subnet-053a640b55610b633"]) and merge into each of the SUTs attributes currently null public_subnet_ids.
  suts_attributes = {
    for sut_key, sut_val in local.common_vars.suts_attributes:
    sut_key => merge(sut_val, {public_subnet_ids = dependency.nw.outputs.public_subnet_ids})
  }
}

terraform {
  after_hook "delete_left_over_log_groups" {
    commands = ["destroy"]
    execute = ["bash", "./deleteLeftOverLogGroups.sh", "${find_in_parent_folders(".env")}"]
    run_on_error = true
  }
}

# redirects stderr (2) into stdout (1), then pipes stdout into tee, which copies it to the terminal and to the log file.
# terragrunt apply -no-color 2>&1 | tee out


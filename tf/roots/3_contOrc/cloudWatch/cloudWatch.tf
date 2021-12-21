// Copyright (C) 2017-2022 BinaryMist Limited. All rights reserved.

// This file is ancillary to PurpleTeam.

// purpleteam-iac-sut is free software: you can redistribute it and/or modify
// it under the terms of the MIT License.

// purpleteam-iac-sut is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// MIT License for more details.

module "aws_cloudwatch_log_group_dmesg" {
  source = "../../../modules/common/aws/managementGovernance/cloudWatch/logGroup"
  name = "/var/log/dmesg"
  retention_in_days = var.retention_in_days
}

// This log stream is written even after this resource is removed by terraform, so when you recreate it, we get a message that it already exists.
// When tearing down, pays to remove this log group before `terraform apply` so that the group can be created with a 30 day retention instead of the defualt "Never Expire".
// The userData.tpl will create the log group as "Never Expire" if we don't create it via terraform here.
module "aws_cloudwatch_log_group_messages" {
  source = "../../../modules/common/aws/managementGovernance/cloudWatch/logGroup"
  name = "/var/log/messages"
  retention_in_days = var.retention_in_days
}

module "aws_cloudwatch_log_group_ecs_init" {
  source = "../../../modules/common/aws/managementGovernance/cloudWatch/logGroup"
  name = "/var/log/ecs/ecs-init.log"
  retention_in_days = var.retention_in_days
}

// This log stream is written even after this resource is removed by terraform, so when you recreate it, we get a message that it already exists.
// When tearing down, pays to remove this log group before `terraform apply` so that the group can be created with a 30 day retention instead of the defualt "Never Expire".
// The userData.tpl will create the log group as "Never Expire" if we don't don't create it via terraform here.
module "aws_cloudwatch_log_group_ecs_agent" {
  source = "../../../modules/common/aws/managementGovernance/cloudWatch/logGroup"
  name = "/var/log/ecs/ecs-agent.log"
  retention_in_days = var.retention_in_days
}

module "aws_cloudwatch_log_group_ecs_audit" {
  source = "../../../modules/common/aws/managementGovernance/cloudWatch/logGroup"
  name = "/var/log/ecs/audit.log"
  retention_in_days = var.retention_in_days
}

module "aws_cloudwatch_log_group_audit_agent" {
  source = "../../../modules/common/aws/managementGovernance/cloudWatch/logGroup"
  name = "/var/log/audit/audit.log"
  retention_in_days = var.retention_in_days
}

module "aws_cloudwatch_log_group_secure" {
  source = "../../../modules/common/aws/managementGovernance/cloudWatch/logGroup"
  name = "/var/log/secure"
  retention_in_days = var.retention_in_days
}

////////////////////////////////////
// SUT Containers
////////////////////////////////////

module "aws_cloudwatch_log_group_sut" {
  source = "../../../modules/common/aws/managementGovernance/cloudWatch/logGroupsViaMap"
  values = var.sut_log_group_values
}


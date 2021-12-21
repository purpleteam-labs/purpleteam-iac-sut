// Copyright (C) 2017-2022 BinaryMist Limited. All rights reserved.

// This file is ancillary to PurpleTeam.

// purpleteam-iac-sut is free software: you can redistribute it and/or modify
// it under the terms of the MIT License.

// purpleteam-iac-sut is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// MIT License for more details.

locals {
  aws_lb_target_groups = jsondecode(var.aws_lb_target_groups)
  sut_log_group_values = {for k, v in var.suts_attributes : k => {
    log_group_name: "/ecs/${k}"
    retention_in_days: var.log_group_retention_in_days
  }}
}

// Doc: https://medium.com/@bradford_hamilton/deploying-containers-on-amazons-ecs-using-fargate-and-terraform-part-2-2e6f6a3a957f#1e4a
module "cloudWatch" {
  source = "./cloudWatch"
  retention_in_days = var.log_group_retention_in_days
  sut_log_group_values = local.sut_log_group_values
}

module "ecs" {
  source = "../../modules/common/aws/containers/ecs"
  aws_account_id = var.AWS_ACCOUNT_ID
  vpc_id = var.vpc_id
  ecs_task_execution_role = var.ecs_task_execution_role
  aws_region = var.AWS_REGION
  suts_attributes = var.suts_attributes
  ecs_service_role = var.ecs_service_role
  aws_lb_target_groups = local.aws_lb_target_groups
}

module "s3" {
  source = "../../modules/common/aws/storage/s3"
  ec2_instance_public_keys = var.ec2_instance_public_keys
}

// Autoscaling resource: https://medium.com/@bradford_hamilton/deploying-containers-on-amazons-ecs-using-fargate-and-terraform-part-2-2e6f6a3a957f#78b5
module "autoscaling" {
  source = "../../modules/common/aws/compute/ec2/autoscaling"
  aws_region = var.AWS_REGION
  ecs_image_id = var.ecs_image_id
  ecs_instance_profile = var.ecs_instance_profile
  vpc_ec2_instance_security_groups_ids = [var.sg_ssh_id, var.sg_sut_id]
  aws_lb_target_groups = local.aws_lb_target_groups
  suts_attributes = var.suts_attributes
  aws_s3_bucket_object_sut_public_keys = module.s3.aws_s3_bucket_object_sut_public_keys
}

// Copyright (C) 2017-2022 BinaryMist Limited. All rights reserved.

// This file is ancillary to PurpleTeam.

// purpleteam-iac-sut is free software: you can redistribute it and/or modify
// it under the terms of the MIT License.

// purpleteam-iac-sut is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// MIT License for more details.

data "aws_caller_identity" "current" {}

//////////////////////////////////
// IAM
//////////////////////////////////

module "eC2RoleForLaunchingEC2Instances" {
  source = "../../modules/common/aws/securityIdentityCompliance/iam/1_eC2RoleForLaunchingEC2Instances"
}

module "eCSRoleForECSServiceToCallELB" {
  source = "../../modules/common/aws/securityIdentityCompliance/iam/2_eCSRoleForECSServiceToCallELB"
}

module "eCSTaskRole" {
  source = "../../modules/common/aws/securityIdentityCompliance/iam/3_eCSTaskRole"
  aws_region = var.AWS_REGION
  account_id = data.aws_caller_identity.current.account_id
}

module "eCSTaskExecutionRole" {
  source = "../../modules/common/aws/securityIdentityCompliance/iam/4_eCSTaskExecutionRole"
  aws_iam_policy_document_ecs_task_assume_role_policy = module.eCSTaskRole.aws_iam_policy_document_ecs_task_assume_role_policy
  aws_region = var.AWS_REGION
  account_id = data.aws_caller_identity.current.account_id
}

module "cloudWatchRoleForAPIGateway" {
  source = "../../modules/common/aws/securityIdentityCompliance/iam/5_cloudWatchRoleForAPIGateway"
}

//////////////////////////////////
// ECR
//////////////////////////////////

module "sut_repo" {
  source = "../../modules/common/aws/containers/ecr/repository"
  suts_attributes = var.suts_attributes
}


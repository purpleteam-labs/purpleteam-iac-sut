// Copyright (C) 2017-2022 BinaryMist Limited. All rights reserved.

// This file is ancillary to PurpleTeam.

// purpleteam-iac-sut is free software: you can redistribute it and/or modify
// it under the terms of the MIT License.

// purpleteam-iac-sut is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// MIT License for more details.

// IAM instance profile used for EC2 Launch Templates.
output "ecs_instance_profile" {
  value = module.eC2RoleForLaunchingEC2Instances.ecs_instance_profile
  sensitive = true
}

// IAM role used for the ECS Services to make calls to the load balancer on our behalf.
output "ecs_service_role" {
  value = module.eCSRoleForECSServiceToCallELB.ecs_service_role
  sensitive = true
}

// ECS task execution role that the ECS container agent and the Docker daemon can assume.
output "ecs_task_execution_role" {
  value = module.eCSTaskExecutionRole.ecs_task_execution_role
  sensitive = true
}

// Consumed in api root.
output "api_gateway_cloudwatch_role" {
  value = module.cloudWatchRoleForAPIGateway.aws_iam_role_cloudwatch
  sensitive = true
}

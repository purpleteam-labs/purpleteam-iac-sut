// Copyright (C) 2017-2022 BinaryMist Limited. All rights reserved.

// This file is ancillary to PurpleTeam.

// purpleteam-iac-sut is free software: you can redistribute it and/or modify
// it under the terms of the MIT License.

// purpleteam-iac-sut is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// MIT License for more details.

///////////////////////////
// ECS task execution role.
///////////////////////////
// Doc: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_execution_IAM_role.html

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "pt-ecs-task-execution-role"
  assume_role_policy = var.aws_iam_policy_document_ecs_task_assume_role_policy.json

  description = "ECS task execution role"

  tags = {
    source = "iac-static-iam"
  }
}

// Currently the below is a bit of a guess as to what's required.
// Doc: Systems Manager Parameter Store: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/specifying-sensitive-data-parameters.html
data "aws_iam_policy_document" "ecs_task_execution_policy" {
  statement {
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "ssm:DescribeParameters"
    ]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "ssm:GetParameters"
    ]
    resources = [
      "arn:aws:ssm:${var.aws_region}:${var.account_id}:parameter/NODEGOAT_*"
    ]
  }
}
resource "aws_iam_role_policy" "ecs_task_execution_role_policy" {
    name = "pt-ecs-task-execution-role-policy"
    role = aws_iam_role.ecs_task_execution_role.id
    policy = data.aws_iam_policy_document.ecs_task_execution_policy.json
}


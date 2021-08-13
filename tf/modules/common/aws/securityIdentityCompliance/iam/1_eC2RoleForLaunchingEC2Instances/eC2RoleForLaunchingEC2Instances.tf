// Copyright (C) 2017-2021 BinaryMist Limited. All rights reserved.

// This file is part of PurpleTeam.

// PurpleTeam is free software: you can redistribute it and/or modify
// it under the terms of the MIT License.

// PurpleTeam is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// MIT License for more details.

////////////////////////////////////////////////////////////////////////
// IAM profile for EC2 Launch Template used for Auto Scaling Groups.
////////////////////////////////////////////////////////////////////////

data "aws_iam_policy_document" "ecs_instance_assume_role_policy" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_instance_role" {
  name = "pt-ecs-instance-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_instance_assume_role_policy.json

  description = "IAM instance profile used for the ecs(?) launch configuration"

  tags = {
    source = "iac-static-iam"
  }
}

data "aws_iam_policy_document" "ecs_instance_policy" {
  statement {
    effect = "Allow"
    actions = [
      "ec2:DescribeTags",
      "ecs:CreateCluster",
      "ecs:DeregisterContainerInstance",
      "ecs:DiscoverPollEndpoint",
      "ecs:Poll",
      "ecs:RegisterContainerInstance",
      "ecs:StartTelemetrySession",
      "ecs:Submit*",
      "ecs:StartTask",
      "ecs:UpdateContainerInstancesState",
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage"
    ]

    // According to doc, This is required by AWS if used for an IAM policy.
    // https://www.terraform.io/docs/providers/aws/d/iam_policy_document.html
    // Have looked in logs during creation, and there is no mention of resources, so I think it needs to be *
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams"
    ]
    resources = ["arn:aws:logs:*:*:*"]
  }
  statement {
    effect = "Allow"
    actions = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::sut-public-keys"]
  }
  statement {
    effect = "Allow"
    actions = ["s3:GetObject"]
    resources = ["arn:aws:s3:::sut-public-keys/*"]
  }
}

resource "aws_iam_role_policy" "ecs-instance-role-policy" {
  name = "pt-ecs-instance-role-policy"
  role = aws_iam_role.ecs_instance_role.id
  policy = data.aws_iam_policy_document.ecs_instance_policy.json
}

resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name = "pt-ecs-instance-profile"
  role = aws_iam_role.ecs_instance_role.name
}

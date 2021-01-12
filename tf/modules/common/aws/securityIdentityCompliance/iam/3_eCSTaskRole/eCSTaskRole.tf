// Copyright (C) 2017-2021 BinaryMist Limited. All rights reserved.

// This file is part of purpleteam.

// purpleteam is free software: you can redistribute it and/or modify
// it under the terms of the MIT License.

// purpleteam is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// MIT License for more details.

/////////////////
// ECS task role.
/////////////////
// Doc: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_IAM_role.html

data "aws_iam_policy_document" "ecs_task_assume_role_policy" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}


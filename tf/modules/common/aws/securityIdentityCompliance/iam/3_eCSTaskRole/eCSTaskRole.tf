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
resource "aws_iam_role" "ecs_task_role" {
  name = "pt-ecs-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role_policy.json

  description = "ECS task role"

  tags = {
    source = "iac-static-iam"
  }
}


data "aws_iam_policy_document" "ecs_task_policy" {
  statement {
    effect = "Allow"
    actions = [
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
resource "aws_iam_role_policy" "ecs_task_role_policy" {
  name = "pt-ecs-task-role-policy"
  role = aws_iam_role.ecs_task_role.id
  policy = data.aws_iam_policy_document.ecs_task_policy.json
}


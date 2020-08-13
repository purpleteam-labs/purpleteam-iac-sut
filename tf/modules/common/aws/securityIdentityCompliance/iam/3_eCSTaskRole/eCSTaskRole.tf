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


// ECS task role that allows your ECS container task to make calls to other AWS services.
output "ecs_task_role" {
  value = aws_iam_role.ecs_task_role.arn
}
output "aws_iam_policy_document_ecs_task_assume_role_policy" {
  value = data.aws_iam_policy_document.ecs_task_assume_role_policy
}


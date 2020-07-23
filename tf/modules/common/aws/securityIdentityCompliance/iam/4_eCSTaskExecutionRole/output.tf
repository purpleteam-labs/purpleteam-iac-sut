// ECS task execution role that the ECS container agent and the Docker daemon can assume.
output "ecs_task_execution_role" {
  value = aws_iam_role.ecs_task_execution_role.arn
}


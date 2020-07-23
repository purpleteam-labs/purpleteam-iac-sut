// IAM role used for the ECS Services to make calls to the load balancer on our behalf.
output "ecs_service_role" {
  value = aws_iam_role.ecs_service_role.name
}


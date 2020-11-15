// IAM instance profile used for EC2 Launch Templates.
output "ecs_instance_profile" {
  value = aws_iam_instance_profile.ecs_instance_profile.arn
}

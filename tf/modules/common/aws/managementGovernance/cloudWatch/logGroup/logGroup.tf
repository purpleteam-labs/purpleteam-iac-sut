// Todo: Encrypt logs. Use kms_key_id within the aws_cloudwatch_log_group resources.

resource "aws_cloudwatch_log_group" "pt" {
  name              = var.name
  retention_in_days = var.retention_in_days
}

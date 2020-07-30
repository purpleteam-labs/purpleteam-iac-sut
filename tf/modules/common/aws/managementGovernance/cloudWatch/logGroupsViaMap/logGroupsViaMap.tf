// Todo: Encrypt logs. Use kms_key_id within the aws_cloudwatch_log_group resources.

resource "aws_cloudwatch_log_group" "pt" {
  for_each = var.values

  name              = each.value.log_group_name
  retention_in_days = each.value.retention_in_days
}

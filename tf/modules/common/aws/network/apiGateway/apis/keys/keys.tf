resource "aws_api_gateway_api_key" "sut" {
  for_each = var.key_and_usage_plan_id_keyed_by_tester

  depends_on = [var.aws_api_gateway_usage_plan_sut]

  name = each.key
  enabled = true
  value = each.value.api_key
  tags = {
    source = "iac-api"
  }
}

resource "aws_api_gateway_usage_plan_key" "plan_key_integration" {
  for_each = var.key_and_usage_plan_id_keyed_by_tester

  key_id = aws_api_gateway_api_key.sut[each.key].id
  key_type = "API_KEY"
  usage_plan_id = each.value.usage_plan_id
}

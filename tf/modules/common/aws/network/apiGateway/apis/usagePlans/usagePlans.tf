resource "aws_api_gateway_usage_plan" "sut" {
  for_each = var.usage_plan_values

  depends_on = [var.stages]

  name         = each.key
  description  = each.value.description
  product_code = each.value.product_code

  api_stages {
    api_id = var.api_id
    stage  = each.value.stage_name
  }

  quota_settings {
    limit = each.value.quota_settings.limit
    offset = each.value.quota_settings.offset
    period = each.value.quota_settings.period
  }
  
  throttle_settings {
    burst_limit = each.value.throttle_settings.burst_limit
    rate_limit = each.value.throttle_settings.rate_limit
  }
}

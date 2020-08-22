output "usage_plans" {
  value = {
    for plan_key, plan_val in aws_api_gateway_usage_plan.sut:
    plan_key => plan_val
  }

  sensitive = false
}
// To specify dependency due to API Gateway's flaws.
output "aws_api_gateway_usage_plan_sut" {
  value = aws_api_gateway_usage_plan.sut.*
}

variable "key_and_usage_plan_id_keyed_by_tester" {
  type = map(object({
    api_key = string
    usage_plan_id = string
  }))
}
// To specify dependency due to API Gateway's flaws.
variable "aws_api_gateway_usage_plan_sut" {}
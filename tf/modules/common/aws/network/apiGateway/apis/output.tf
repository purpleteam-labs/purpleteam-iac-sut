output "stages" {
  value = aws_api_gateway_stage.sut.*
}
output "aws_api_gateway_rest_api_suts" {
  value = aws_api_gateway_rest_api.sut
}

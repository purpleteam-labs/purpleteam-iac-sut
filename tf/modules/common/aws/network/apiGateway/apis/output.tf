output "stages" {
  value = aws_api_gateway_stage.sut.*
}
output "aws_api_gateway_rest_api_sut_id" {
  value = aws_api_gateway_rest_api.sut.id
}

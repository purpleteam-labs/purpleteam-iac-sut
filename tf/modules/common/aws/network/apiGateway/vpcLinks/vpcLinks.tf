resource "aws_api_gateway_vpc_link" "sut_nlb" {
  name        = "sut_api_gateway_vpc_link_to_${var.aws_lb_name}"
  description = "SUT API Gateway VPC Link to ${var.aws_lb_name}"
  target_arns = ["${var.aws_lb_arn}"]
}

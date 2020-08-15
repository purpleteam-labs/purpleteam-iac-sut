// Doc:
//   [Build an API with API Gateway Private Integration](https://docs.aws.amazon.com/apigateway/latest/developerguide/getting-started-with-private-integration.html)
//   [Build an API with HTTP Proxy Integration](https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-create-api-as-simple-proxy-for-http.html)

module "vpcLinks" {
  source = "../../modules/common/aws/network/apiGateway/vpcLinks"
  aws_lb_name = var.aws_lb_name
  aws_lb_arn = var.aws_lb_arn
}

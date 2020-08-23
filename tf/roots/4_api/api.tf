// Doc:
//   [Build an API with API Gateway Private Integration](https://docs.aws.amazon.com/apigateway/latest/developerguide/getting-started-with-private-integration.html)
//   [Build an API with HTTP Proxy Integration](https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-create-api-as-simple-proxy-for-http.html)

module "vpcLinks" {
  source = "../../modules/common/aws/network/apiGateway/vpcLinks"
  aws_lb_name = var.aws_lb_name
  aws_lb_arn = var.aws_lb_arn
}

module "apis" {
  source = "../../modules/common/aws/network/apiGateway/apis"
  suts_attributes = var.suts_attributes
  api_gateway_cloudwatch_role = var.api_gateway_cloudwatch_role
  vpc_link_sut_nlb_id = module.vpcLinks.aws_api_gateway_vpc_link_sut_nlb_id

  stage_values = var.stage_values
  aws_lb_dns_name = var.aws_lb_dns_name
}

module "domainNames" {
  source = "../../modules/common/aws/network/apiGateway/domainNames"
  api_cert_arn = var.api_cert_arn
  purpleteamlabs_domain_name = var.purpleteamlabs_domain_name
  purpleteamlabs_sut_cname = var.purpleteamlabs_sut_cname
  purpleteamlabs_cloudflare_dns_zone_id = var.purpleteamlabs_cloudflare_dns_zone_id
  stages = module.apis.stages
  aws_api_gateway_rest_api_suts = module.apis.aws_api_gateway_rest_api_suts
  stage_values = var.stage_values
  suts_attributes = var.suts_attributes
}




/*
module "usagePlans" {
  source = "../../modules/common/aws/network/apiGateway/apis/usagePlans"
  api_id = module.apis.aws_api_gateway_rest_api_sut_id
  usage_plan_values = var.usage_plan_values
  stages = module.apis.stages
}

// Create API keys and assign them to the tester selected usage plan
module "keys" {
  source = "../../modules/common/aws/network/apiGateway/apis/keys"
  key_and_usage_plan_id_keyed_by_tester = {
    for tester_key, tester_val in var.testers_attributes:
    tester_key => {
      api_key: tester_val.api_gateway_api_key
      usage_plan_id: module.usagePlans.usage_plans[tester_val.api_gateway_usage_plan].id
    }
  }
  // To specify dependency due to API Gateway's flaws.
  aws_api_gateway_usage_plan_sut = module.usagePlans.aws_api_gateway_usage_plan_sut
}
*/
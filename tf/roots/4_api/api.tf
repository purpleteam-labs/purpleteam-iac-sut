// Copyright (C) 2017-2021 BinaryMist Limited. All rights reserved.

// This file is part of purpleteam.

// purpleteam is free software: you can redistribute it and/or modify
// it under the terms of the MIT License.

// purpleteam is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// MIT License for more details.

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

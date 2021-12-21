// Copyright (C) 2017-2022 BinaryMist Limited. All rights reserved.

// This file is ancillary to PurpleTeam.

// purpleteam-iac-sut is free software: you can redistribute it and/or modify
// it under the terms of the MIT License.

// purpleteam-iac-sut is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// MIT License for more details.

resource "aws_api_gateway_account" "sut" {
  cloudwatch_role_arn = var.api_gateway_cloudwatch_role
}

resource "aws_api_gateway_rest_api" "sut" {
  for_each = var.suts_attributes

  name        = "${each.value.name}-sut-api"
  description = "${each.value.name} SUT API"
  endpoint_configuration {
    types = ["EDGE"]
  }
}

///////////////////////////
// Resources (Routes)
///////////////////////////
resource "aws_api_gateway_resource" "proxy_plus" {
  for_each = var.suts_attributes

  rest_api_id = aws_api_gateway_rest_api.sut[each.key].id
  parent_id   = aws_api_gateway_rest_api.sut[each.key].root_resource_id
  path_part   = "{proxy+}"
}

///////////////////////////
// Methods (HTTP Verbs)
///////////////////////////
resource "aws_api_gateway_method" "root_get" {
  for_each = var.suts_attributes

  rest_api_id          = aws_api_gateway_rest_api.sut[each.key].id
  resource_id          = aws_api_gateway_rest_api.sut[each.key].root_resource_id
  http_method          = "GET"
  authorization        = "NONE"
  api_key_required     = false
  request_parameters   = {}
}

resource "aws_api_gateway_method" "proxy_plus_any" {
  for_each = var.suts_attributes

  rest_api_id          = aws_api_gateway_rest_api.sut[each.key].id
  resource_id          = aws_api_gateway_resource.proxy_plus[each.key].id
  http_method          = "ANY"
  authorization        = "NONE"
  api_key_required     = false
  request_parameters   = {"method.request.path.proxy" = true}
}

///////////////////////////
// Integrations
///////////////////////////
resource "aws_api_gateway_integration" "root_get" {
  for_each = var.suts_attributes

  depends_on = [
    aws_api_gateway_method.root_get
  ]

  rest_api_id = aws_api_gateway_rest_api.sut[each.key].id
  resource_id = aws_api_gateway_rest_api.sut[each.key].root_resource_id
  http_method = aws_api_gateway_method.root_get[each.key].http_method
  type        = "HTTP_PROXY"
  uri         = "http://$${stageVariables.nlbUrl}:${each.value.sut_lb_listener_port}/"
  integration_http_method = "GET"
  connection_type = "VPC_LINK"
  connection_id = "$${stageVariables.vpcLinkId}"
}

resource "aws_api_gateway_integration" "proxy_plus_any" {
  for_each = var.suts_attributes

  depends_on = [
    aws_api_gateway_method.proxy_plus_any
  ]

  rest_api_id = aws_api_gateway_rest_api.sut[each.key].id
  resource_id = aws_api_gateway_resource.proxy_plus[each.key].id
  http_method = aws_api_gateway_method.proxy_plus_any[each.key].http_method
  type        = "HTTP_PROXY"
  uri         = "http://$${stageVariables.nlbUrl}:${each.value.sut_lb_listener_port}/{proxy}"
  integration_http_method = "ANY"
  connection_type = "VPC_LINK"
  connection_id = "$${stageVariables.vpcLinkId}"
  cache_key_parameters = ["method.request.path.proxy"]
  request_parameters = {"integration.request.path.proxy" = "method.request.path.proxy"}
}

///////////////////////////
// Method Responses
///////////////////////////
resource "aws_api_gateway_method_response" "root_get" {
  for_each = var.suts_attributes

  rest_api_id = aws_api_gateway_rest_api.sut[each.key].id
  resource_id = aws_api_gateway_rest_api.sut[each.key].root_resource_id
  http_method = aws_api_gateway_method.root_get[each.key].http_method
  status_code = "200"

  # response_models = {
  #   "application/json" = "Empty"
  # }
}

resource "aws_api_gateway_method_response" "proxy_plus_any" {
  for_each = var.suts_attributes

  rest_api_id = aws_api_gateway_rest_api.sut[each.key].id
  resource_id = aws_api_gateway_resource.proxy_plus[each.key].id
  http_method = aws_api_gateway_method.proxy_plus_any[each.key].http_method
  status_code = "200"

  # response_models = {
  #   "application/json" = "Empty"
  # }
}

///////////////////////////
// Integration Responses
///////////////////////////
resource "aws_api_gateway_integration_response" "root_get" {
  for_each = var.suts_attributes

  rest_api_id = aws_api_gateway_rest_api.sut[each.key].id
  resource_id = aws_api_gateway_rest_api.sut[each.key].root_resource_id
  http_method = aws_api_gateway_method.root_get[each.key].http_method
  status_code = aws_api_gateway_method_response.root_get[each.key].status_code

  //selection_pattern = "" // default

  # response_templates = {
  #   "application/json" = ""
  # } 

  depends_on = [
    aws_api_gateway_integration.root_get
  ]
}

resource "aws_api_gateway_integration_response" "proxy_plus_any" {
  for_each = var.suts_attributes

  rest_api_id = aws_api_gateway_rest_api.sut[each.key].id
  resource_id = aws_api_gateway_resource.proxy_plus[each.key].id
  http_method = aws_api_gateway_method.proxy_plus_any[each.key].http_method
  status_code = aws_api_gateway_method_response.proxy_plus_any[each.key].status_code

  //selection_pattern = "" // default

  # response_templates = {
  #   "application/json" = ""
  # } 

  depends_on = [
    aws_api_gateway_integration.proxy_plus_any
  ]
}

///////////////////////////
// Deployment
///////////////////////////
resource "aws_api_gateway_deployment" "sut_deploy" {
  for_each = var.suts_attributes

  depends_on  = [
    aws_api_gateway_integration.root_get,
    aws_api_gateway_integration.proxy_plus_any
  ]
  rest_api_id = aws_api_gateway_rest_api.sut[each.key].id
  // Doc: Discussion around why setting a stage_name here doesn't work:
  //   https://github.com/terraform-providers/terraform-provider-aws/issues/1153
  //   https://github.com/terraform-providers/terraform-provider-aws/issues/2918
  //   https://github.com/terraform-providers/terraform-provider-aws/issues/8049
  //stage_name  = var.stage_name
  //stage_name  = ""

  // Following two lines are to update this resource when new deployments are manually made in the console.
  //   Doc: https://github.com/terraform-providers/terraform-provider-aws/issues/162
  //   Doc: This issue (https://github.com/hashicorp/terraform/issues/6613) lead to the above one.
  lifecycle { create_before_destroy = true }
  triggers = {
    redeployment = sha1(join(",", tolist([
      jsonencode(aws_api_gateway_integration.root_get),
      jsonencode(aws_api_gateway_integration.proxy_plus_any)
    ])))
  }
}

///////////////////////////
// CloudWatch Logs
///////////////////////////
// Doc: https://medium.com/@bradford_hamilton/deploying-containers-on-amazons-ecs-using-fargate-and-terraform-part-2-2e6f6a3a957f#1e4a
// Doc:
//   Access and execution logs: https://seed.run/blog/whats-the-difference-between-access-logs-and-execution-logs-in-api-gateway
module "cloudwatchLogGroupsAccessLogs" {
  source = "../../../managementGovernance/cloudWatch/logGroupsViaMap"

  values = {
    for k, v in aws_api_gateway_rest_api.sut:
    k => {
      log_group_name: "API-Gateway-Access-Logs_${v.id}/one_and_only_stage"
      retention_in_days: var.stage_values["one_and_only_stage"].access_log_group_retention_in_days
    }
  }
}
module "cloudwatchLogGroupsExecutionLogs" {
  source = "../../../managementGovernance/cloudWatch/logGroupsViaMap"

  values = {
    for k, v in aws_api_gateway_rest_api.sut:
    k => {
      log_group_name: "API-Gateway-Execution-Logs_${v.id}/one_and_only_stage"
      retention_in_days: var.stage_values["one_and_only_stage"].access_log_group_retention_in_days
    }
  }
}

///////////////////////////
// Stage
///////////////////////////
resource "aws_api_gateway_stage" "sut" {
  for_each = var.suts_attributes

  depends_on = [
    module.cloudwatchLogGroupsAccessLogs.cloudwatch_log_groups,
    module.cloudwatchLogGroupsExecutionLogs.cloudwatch_log_groups
  ]
  stage_name    = "one_and_only_stage"
  rest_api_id   = aws_api_gateway_rest_api.sut[each.key].id
  deployment_id = aws_api_gateway_deployment.sut_deploy[each.key].id

  access_log_settings {
    destination_arn = module.cloudwatchLogGroupsAccessLogs.cloudwatch_log_groups[each.key].arn
    format = jsonencode({
      "requestId":"$context.requestId",
      "ip": "$context.identity.sourceIp",
      "caller":"$context.identity.caller",
      "user":"$context.identity.user",
      "requestTime":"$context.requestTime",
      "httpMethod":"$context.httpMethod",
      "resourcePath":"$context.resourcePath",
      "status":"$context.status",
      "protocol":"$context.protocol",
      "responseLength":"$context.responseLength"
    })
  }

  variables = {
    vpcLinkId = var.vpc_link_sut_nlb_id
    nlbUrl = var.aws_lb_dns_name
  }
}

resource "aws_api_gateway_method_settings" "sut" {
  for_each = var.suts_attributes

  depends_on = [aws_api_gateway_stage.sut]

  rest_api_id = aws_api_gateway_rest_api.sut[each.key].id
  stage_name = "one_and_only_stage"

  // Doc for enabling logging for stage: https://github.com/terraform-providers/terraform-provider-aws/issues/4448
  method_path = "*/*"

  // Stages settings
  settings {
    metrics_enabled    = var.stage_values["one_and_only_stage"].settings.metrics_enabled
    data_trace_enabled = var.stage_values["one_and_only_stage"].settings.data_trace_enabled
    logging_level      = var.stage_values["one_and_only_stage"].settings.logging_level

    throttling_rate_limit  = var.stage_values["one_and_only_stage"].settings.throttling_rate_limit
    throttling_burst_limit = var.stage_values["one_and_only_stage"].settings.throttling_burst_limit
  }
}

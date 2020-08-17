resource "aws_api_gateway_account" "sut" {
  cloudwatch_role_arn = var.api_gateway_cloudwatch_role
}

resource "random_id" "id" {
	byte_length = 8
}

resource "aws_api_gateway_rest_api" "sut" {
  name        = "sut-api-${random_id.id.hex}" // Allows us to create duplicate APIs if necessary.
  description = "Purpleteam SUT API"
  endpoint_configuration {
    types = ["EDGE"]
  }
}

///////////////////////////
// Resources (Routes)
///////////////////////////
resource "aws_api_gateway_resource" "sut" {
  for_each = var.suts_attributes

  rest_api_id = aws_api_gateway_rest_api.sut.id
  parent_id   = aws_api_gateway_rest_api.sut.root_resource_id
  path_part   = lookup(each.value, "id")
}
resource "aws_api_gateway_resource" "proxy_plus" {
  for_each = var.suts_attributes

  rest_api_id = aws_api_gateway_rest_api.sut.id
  parent_id   = aws_api_gateway_resource.sut[each.key].id
  path_part   = "{proxy+}"
}

///////////////////////////
// Methods (HTTP Verbs)
///////////////////////////
resource "aws_api_gateway_method" "sut" {
  for_each = var.suts_attributes

  rest_api_id          = aws_api_gateway_rest_api.sut.id
  resource_id          = aws_api_gateway_resource.proxy_plus[each.key].id
  http_method          = "ANY"
  authorization        = "NONE"
  api_key_required     = true
  request_parameters   = {"method.request.path.proxy" = true}
}

///////////////////////////
// Integrations
///////////////////////////
resource "aws_api_gateway_integration" "sut" {
  for_each = var.suts_attributes

  depends_on = [
    aws_api_gateway_method.sut
  ]

  rest_api_id = aws_api_gateway_rest_api.sut.id
  resource_id = aws_api_gateway_resource.proxy_plus[each.key].id
  http_method = aws_api_gateway_method.sut[each.key].http_method
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
resource "aws_api_gateway_method_response" "sut" {
  for_each = var.suts_attributes

  rest_api_id = aws_api_gateway_rest_api.sut.id
  resource_id = aws_api_gateway_resource.proxy_plus[each.key].id
  http_method = aws_api_gateway_method.sut[each.key].http_method
  status_code = "200"

  # response_models = {
  #   "application/json" = "Empty"
  # }
}

///////////////////////////
// Integration Responses
///////////////////////////
resource "aws_api_gateway_integration_response" "sut" {
  for_each = var.suts_attributes

  rest_api_id = aws_api_gateway_rest_api.sut.id
  resource_id = aws_api_gateway_resource.proxy_plus[each.key].id
  http_method = aws_api_gateway_method.sut[each.key].http_method
  status_code = aws_api_gateway_method_response.sut[each.key].status_code

  //selection_pattern = "" // default

  # response_templates = {
  #   "application/json" = ""
  # } 

  depends_on = [
    aws_api_gateway_integration.sut//,
    //aws_api_gateway_method_response.sut
  ]
}

///////////////////////////
// Deployment
///////////////////////////
resource "aws_api_gateway_deployment" "sut_deploy" {
  depends_on  = [
    aws_api_gateway_integration.sut    
  ]
  rest_api_id = aws_api_gateway_rest_api.sut.id
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
    redeployment = sha1(join(",", list(
      jsonencode(aws_api_gateway_integration.sut),
    )))
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
    for stage_key, stage_val in var.stage_values:
    stage_key => {
      log_group_name: "API-Gateway-Access-Logs_${aws_api_gateway_rest_api.sut.id}/${stage_key}"
      retention_in_days: stage_val.access_log_group_retention_in_days
    }
  }
}
module "cloudwatchLogGroupsExecutionLogs" {
  source = "../../../managementGovernance/cloudWatch/logGroupsViaMap"

  values = {
    for stage_key, stage_val in var.stage_values:
    stage_key => {
      log_group_name: "API-Gateway-Execution-Logs_${aws_api_gateway_rest_api.sut.id}/${stage_key}"
      retention_in_days: stage_val.execution_log_group_retention_in_days
    }
  }
}

///////////////////////////
// Stage
///////////////////////////
resource "aws_api_gateway_stage" "sut" {
  for_each = var.stage_values

  depends_on = [
    module.cloudwatchLogGroupsAccessLogs.cloudwatch_log_groups,
    module.cloudwatchLogGroupsExecutionLogs.cloudwatch_log_groups
  ]
  stage_name    = each.key
  rest_api_id   = aws_api_gateway_rest_api.sut.id
  deployment_id = aws_api_gateway_deployment.sut_deploy.id

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
    nlbUrl = "${var.aws_lb_dns_name}"
  }
}

resource "aws_api_gateway_method_settings" "sut" {
  for_each = var.stage_values

  depends_on = [aws_api_gateway_stage.sut]

  rest_api_id = aws_api_gateway_rest_api.sut.id
  stage_name  = each.key

  // Doc for enabling logging for stage: https://github.com/terraform-providers/terraform-provider-aws/issues/4448
  method_path = "*/*"

  // Stages settings
  settings {
    metrics_enabled    = each.value.settings.metrics_enabled
    data_trace_enabled = each.value.settings.data_trace_enabled
    logging_level      = each.value.settings.logging_level
  }
}

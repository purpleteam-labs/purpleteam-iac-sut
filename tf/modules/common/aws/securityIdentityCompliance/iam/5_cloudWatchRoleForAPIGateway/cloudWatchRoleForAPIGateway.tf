// Doc: CloudWatch Logging Permissions: https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-logging.html
data "aws_iam_policy_document" "api_gateway_assume_role_policy" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = ["apigateway.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "cloudwatch" {
  name = "pt-api-gateway-cloudwatch-global"
  assume_role_policy = data.aws_iam_policy_document.api_gateway_assume_role_policy.json
  description = "API Gateway Role"
  tags = {
    source = "iac-static-iam"
  }
}

data "aws_iam_policy_document" "api_gateway_push_to_cloudwatch_logs_policy" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents",
      "logs:GetLogEvents",
      "logs:FilterLogEvents"
    ]
    resources = ["*"]
  }
}
resource "aws_iam_role_policy" "cloudwatch" {
  name = "pt-api-gateway-role-policy"
  role = aws_iam_role.cloudwatch.id
  policy = data.aws_iam_policy_document.api_gateway_push_to_cloudwatch_logs_policy.json
}


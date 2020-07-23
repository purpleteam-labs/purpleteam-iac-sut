////////////////////////////
// IAM role for ECS service.
////////////////////////////

data "aws_iam_policy_document" "ecs_service_assume_role_policy" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = ["ecs.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_service_role" {
  name = "pt-ecs-service-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_service_assume_role_policy.json

  description = "IAM role used for the ecs services"

  tags = {
    source = "iac-static-iam"
  }
}

data "aws_iam_policy_document" "ecs_service_policy" {
  statement {
    effect = "Allow"
    actions = [
      "elasticloadbalancing:Describe*",
      "elasticloadbalancing:DeregisterTargets",
      "elasticloadbalancing:RegisterTargets",
      //"elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
      //"elasticloadbalancing:RegisterInstancesWithLoadBalancer",
      "ec2:Describe*",
      "ec2:AuthorizeSecurityGroupIngress"
    ]

    // According to doc, This is required by AWS if used for an IAM policy.
    // https://www.terraform.io/docs/providers/aws/d/iam_policy_document.html
    // Have looked in logs during creation, and there is no mention of resources, so I think it needs to be *
    resources = ["*"]
  }
}
resource "aws_iam_role_policy" "ecs_service_role_policy" {
    name = "pt-ecs-service-role"
    role = aws_iam_role.ecs_service_role.id
    policy = data.aws_iam_policy_document.ecs_service_policy.json
}


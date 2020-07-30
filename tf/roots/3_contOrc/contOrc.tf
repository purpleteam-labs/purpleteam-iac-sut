locals {
  aws_lb_target_groups = jsondecode(var.aws_lb_target_groups)
}

// Doc: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/specifying-sensitive-data-parameters.html
module "ssm" {
  source = "../../modules/common/aws/managementGovernance/systemsManager"
  ssm_parameters = var.ssm_parameters
}

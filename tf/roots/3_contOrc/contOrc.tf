locals {
  aws_lb_target_groups = jsondecode(var.aws_lb_target_groups)
  sut_log_group_values = {for k, v in var.suts_attributes : k => {
    log_group_name: "/ecs/${k}"
    retention_in_days: var.log_group_retention_in_days
  }}
}

// Doc: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/specifying-sensitive-data-parameters.html
module "ssm" {
  source = "../../modules/common/aws/managementGovernance/systemsManager"
  ssm_parameters = var.ssm_parameters
}

// Doc: https://medium.com/@bradford_hamilton/deploying-containers-on-amazons-ecs-using-fargate-and-terraform-part-2-2e6f6a3a957f#1e4a
module "cloudWatch" {
  source = "./cloudWatch"
  retention_in_days = var.log_group_retention_in_days
  sut_log_group_values = local.sut_log_group_values
}

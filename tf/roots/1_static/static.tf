data "aws_caller_identity" "current" {}

//////////////////////////////////
// IAM
//////////////////////////////////

module "eC2RoleForLaunchingEC2Instances" {
  source = "../../modules/common/aws/securityIdentityCompliance/iam/1_eC2RoleForLaunchingEC2Instances"
}

module "eCSRoleForECSServiceToCallELB" {
  source = "../../modules/common/aws/securityIdentityCompliance/iam/2_eCSRoleForECSServiceToCallELB"
}

module "eCSTaskRole" {
  source = "../../modules/common/aws/securityIdentityCompliance/iam/3_eCSTaskRole"
  aws_region = var.AWS_REGION
  account_id = data.aws_caller_identity.current.account_id
}

module "eCSTaskExecutionRole" {
  source = "../../modules/common/aws/securityIdentityCompliance/iam/4_eCSTaskExecutionRole"
  aws_iam_policy_document_ecs_task_assume_role_policy = module.eCSTaskRole.aws_iam_policy_document_ecs_task_assume_role_policy
  aws_region = var.AWS_REGION
  account_id = data.aws_caller_identity.current.account_id
}

module "cloudWatchRoleForAPIGateway" {
  source = "../../modules/common/aws/securityIdentityCompliance/iam/5_cloudWatchRoleForAPIGateway"
}

//////////////////////////////////
// ECR
//////////////////////////////////

module "nodeGoat" {
  source = "../../modules/common/aws/containers/ecr/repository"
  repository_name = "suts/nodegoat"
}

# module "anotherSut" {
#   source = "../../modules/common/aws/containers/ecr/repository"
#   repository_name = "suts/somethingElse"
# }

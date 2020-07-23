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

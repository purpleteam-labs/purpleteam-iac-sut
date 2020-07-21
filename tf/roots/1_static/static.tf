data "aws_caller_identity" "current" {}

//////////////////////////////////
// IAM
//////////////////////////////////

module "eC2RoleForLaunchingEC2Instances" {
  source = "../../modules/common/aws/securityIdentityCompliance/iam/1_eC2RoleForLaunchingEC2Instances"
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

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

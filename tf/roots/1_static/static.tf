//////////////////////////////////
// ECR
//////////////////////////////////

module "nodeGoat" {
  source = "../../modules/common/aws/containers/ecr/repository"
  repository_name = "suts/node-goat"
}

# module "anotherSut" {
#   source = "../../modules/common/aws/containers/ecr/repository"
#   repository_name = "suts/somethingElse"
# }

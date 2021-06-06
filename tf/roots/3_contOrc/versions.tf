terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.44.0"
    }
    template = {
      source = "hashicorp/template",
      version = "~> 2.2.0"
    }
  }
  required_version = ">= 0.15"
}

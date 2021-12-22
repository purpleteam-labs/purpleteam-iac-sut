terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.70.0"
    }
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "~> 3.5.0"
    }
    external = {
      source = "hashicorp/external"
      version = "~> 2.1.0"
    }
  }
  required_version = ">= 1.1.2"
}

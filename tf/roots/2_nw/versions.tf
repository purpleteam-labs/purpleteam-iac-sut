terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.44.0"
    }
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "~> 2.21.0"
    }
    external = {
      source = "hashicorp/external"
      version = "~> 2.1.0"
    }
  }
  required_version = ">= 0.15"
}

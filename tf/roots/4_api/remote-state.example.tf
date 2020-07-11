# Using multiple workspaces:
terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "your-org"

    workspaces {
      prefix = "sut_api-" # Name of the state file
    }
  }
}

# Using multiple workspaces:
terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "your-org"

    workspaces {
      prefix = "sut_nw-" # Name of the state file
    }
  }
}

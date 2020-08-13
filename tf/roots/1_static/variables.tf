variable "AWS_REGION" {
  description = "AWS region in use."
  type = string
}

variable "AWS_PROFILE" {
  description = "AWS profile to run commands as."
  type = string
}

provider "aws" {
  profile = var.AWS_PROFILE
  # Bug: region shouldn't be required but is: https://github.com/terraform-providers/terraform-provider-aws/issues/7750
  region = var.AWS_REGION
}

variable "AWS_ACCOUNT_ID" { description = "Not used. Is here to stop Terraform warnings." }

variable "cloudflare_account_id" {
  description = "Used in cloudflare provider. Not used in this root."
  type = string
}
variable "cloudflare_api_token" {
  description = "Used in cloudflare provider. Not used in this root."
  type = string
}

variable "suts_attributes" {
  description = "The attributes that apply to each specific SUT."  
  type = map(object({
    // Populate with properties as required
    purpleteamlabs_sut_cname = string
  }))
}

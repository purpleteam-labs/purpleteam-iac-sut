variable "vpc_id_default" {}
variable "vpc_id" {}
variable "admin_source_ips" {
  description = "The source IPs of our admins."
  type = map(object({
    description = string
    source_ips = list(string)
  }))  
}
variable "non_default_vpc_name" { type = string }

variable "aws_nlb_ips" {}

variable "suts_attributes" {
  description = "The attributes that apply to each specific SUT."  
  type = map(object({
    // Populate with properties as required
    container_port = number
  }))
}

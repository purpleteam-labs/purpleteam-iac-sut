variable "suts_attributes" {
  description = "The attributes that apply to each specific SUT."  
  type = map(object({
    // Populate with properties as required
    id = number
    sut_lb_listener_port = number
  }))
}

variable "api_gateway_cloudwatch_role" { type = string }
variable "stage_values" {
  description = "See top level module for definition."
}
variable "vpc_link_sut_nlb_id" { type = string }
variable "aws_lb_dns_name" { type = string }
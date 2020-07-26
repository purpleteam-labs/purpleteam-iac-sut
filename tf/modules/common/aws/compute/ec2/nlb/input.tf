variable "public_subnet_ids" { type = list(string) }
variable "vpc_id" { type = string }

variable "suts_attributes" {
  description = "The attributes that apply to each specific SUT."  
  type = map(object({
    pt_lb_listener_port = number
  }))
}

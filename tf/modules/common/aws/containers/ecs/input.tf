variable "aws_account_id" { type = string }
variable "vpc_id" { type = string }
variable "ecs_task_execution_role" { type = string }
variable "aws_region" { type = string }

variable "suts_attributes" {
  description = "The attributes that apply to each specific SUT."  
  type = map(object({
    // Populate with properties as required
    container_port = number
    host_port = number
    purpleteamlabs_sut_cname = string
    env = list(object({
      name = string
      value = string
    }))
  }))
}

variable "ecs_service_role" { type = string }
variable "aws_lb_target_groups" { type = map(any) }

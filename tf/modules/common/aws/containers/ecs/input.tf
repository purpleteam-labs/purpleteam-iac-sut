// Copyright (C) 2017-2022 BinaryMist Limited. All rights reserved.

// This file is ancillary to PurpleTeam.

// purpleteam-iac-sut is free software: you can redistribute it and/or modify
// it under the terms of the MIT License.

// purpleteam-iac-sut is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// MIT License for more details.

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
    name = string
    env = list(object({
      name = string
      value = string
    }))
  }))
}

variable "ecs_service_role" { type = string }
variable "aws_lb_target_groups" { type = map(any) }

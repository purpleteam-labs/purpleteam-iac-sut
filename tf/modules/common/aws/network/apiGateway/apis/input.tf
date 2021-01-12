// Copyright (C) 2017-2021 BinaryMist Limited. All rights reserved.

// This file is part of purpleteam.

// purpleteam is free software: you can redistribute it and/or modify
// it under the terms of the MIT License.

// purpleteam is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// MIT License for more details.

variable "suts_attributes" {
  description = "The attributes that apply to each specific SUT."  
  type = map(object({
    // Populate with properties as required
    id = number
    sut_lb_listener_port = number
    name: string
  }))
}

variable "api_gateway_cloudwatch_role" { type = string }
variable "stage_values" {
  description = "See top level module for definition."
}
variable "vpc_link_sut_nlb_id" { type = string }
variable "aws_lb_dns_name" { type = string }

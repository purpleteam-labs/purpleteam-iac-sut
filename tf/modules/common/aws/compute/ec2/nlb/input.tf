// Copyright (C) 2017-2021 BinaryMist Limited. All rights reserved.

// This file is part of purpleteam.

// purpleteam is free software: you can redistribute it and/or modify
// it under the terms of the MIT License.

// purpleteam is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// MIT License for more details.

variable "public_subnet_ids" { type = list(string) }
variable "vpc_id" { type = string }

variable "suts_attributes" {
  description = "The attributes that apply to each specific SUT."  
  type = map(object({
    sut_lb_listener_port = number
    container_port = number
  }))
}

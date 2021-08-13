// Copyright (C) 2017-2021 BinaryMist Limited. All rights reserved.

// This file is part of PurpleTeam.

// PurpleTeam is free software: you can redistribute it and/or modify
// it under the terms of the MIT License.

// PurpleTeam is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// MIT License for more details.

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

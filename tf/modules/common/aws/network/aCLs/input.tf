// Copyright (C) 2017-2021 BinaryMist Limited. All rights reserved.

// This file is part of PurpleTeam.

// PurpleTeam is free software: you can redistribute it and/or modify
// it under the terms of the MIT License.

// PurpleTeam is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// MIT License for more details.

variable "vpc_id" {}
variable "default_network_acl_id_of_default_vpc" {}
variable "default_network_acl_id_of_main_vpc" {}
variable "sut_nACL" {
  description = "Rules that will not change often."
  type = object({
    inbound_rules = list(any)
    outbound_rules = list(any)
  })
}
variable "public_and_2nd_mandatory_subnet_for_lb_subnet_ids" { type = list(string) }

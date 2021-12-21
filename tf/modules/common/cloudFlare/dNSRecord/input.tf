// Copyright (C) 2017-2022 BinaryMist Limited. All rights reserved.

// This file is ancillary to PurpleTeam.

// purpleteam-iac-sut is free software: you can redistribute it and/or modify
// it under the terms of the MIT License.

// purpleteam-iac-sut is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// MIT License for more details.

variable "purpleteamlabs_cloudflare_dns_zone_id" { type = string }

variable "name" { 
  description = "The left side of the record."
  type = string
}
variable "content" {
  description = "The right side of the record."
  type = string
}

variable "type" {
  type = string
  default = "CNAME"
}
variable "proxied" {
  type = bool
  default = false
}


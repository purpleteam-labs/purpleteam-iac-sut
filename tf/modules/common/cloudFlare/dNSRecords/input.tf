// Copyright (C) 2017-2021 BinaryMist Limited. All rights reserved.

// This file is part of purpleteam.

// purpleteam is free software: you can redistribute it and/or modify
// it under the terms of the MIT License.

// purpleteam is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// MIT License for more details.

variable "purpleteamlabs_cloudflare_dns_zone_id" { type = string }
variable "name_and_content_keyed_by_sut" { 
  type = map(object({
    name = string
    content = string
  }))
}
variable "type" {
  type = string
  default = "CNAME"
}
variable "proxied" {
  type = bool
  default = false  
}

// Copyright (C) 2017-2022 BinaryMist Limited. All rights reserved.

// This file is ancillary to PurpleTeam.

// purpleteam-iac-sut is free software: you can redistribute it and/or modify
// it under the terms of the MIT License.

// purpleteam-iac-sut is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// MIT License for more details.

resource "cloudflare_record" "pt" {
  zone_id = var.purpleteamlabs_cloudflare_dns_zone_id
  name = var.name
  value = var.content
  type = var.type
  ttl = 1 // 1 == auto
  proxied = var.proxied
}

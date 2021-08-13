// Copyright (C) 2017-2021 BinaryMist Limited. All rights reserved.

// This file is part of PurpleTeam.

// PurpleTeam is free software: you can redistribute it and/or modify
// it under the terms of the MIT License.

// PurpleTeam is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// MIT License for more details.

resource "aws_default_vpc" "default" {}

resource "aws_vpc" "main" {
  cidr_block = var.cidr

  // Needs to be true if supporing private hosted zones in Route53, which is required by ECS Service Discovery.
  // Doc: https://docs.aws.amazon.com/vpc/latest/userguide/vpc-dns.html#vpc-dns-updating
  // Doc: https://docs.aws.amazon.com/vpc/latest/userguide/vpc-dns.html
  // We don't need it enabled.
  enable_dns_support = true // Default: true.
  enable_dns_hostnames = true // Default: false.

  tags = var.vpc_tags
}

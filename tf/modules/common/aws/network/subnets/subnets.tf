// Copyright (C) 2017-2021 BinaryMist Limited. All rights reserved.

// This file is part of PurpleTeam.

// PurpleTeam is free software: you can redistribute it and/or modify
// it under the terms of the MIT License.

// PurpleTeam is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// MIT License for more details.

resource "aws_subnet" "public" {
  count = length(var.subnets_properties)
  vpc_id = var.vpc_id
  cidr_block = lookup(var.subnets_properties[count.index], "cidr")
  availability_zone = lookup(var.subnets_properties[count.index], "availability_zone")

  tags = {
    Name = lookup(var.subnets_properties[count.index], "name")
  }
}

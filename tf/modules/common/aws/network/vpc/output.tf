// Copyright (C) 2017-2021 BinaryMist Limited. All rights reserved.

// This file is part of PurpleTeam.

// PurpleTeam is free software: you can redistribute it and/or modify
// it under the terms of the MIT License.

// PurpleTeam is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// MIT License for more details.

output "vpc_id_default" {
  value = aws_default_vpc.default.id
  description = "The id of the default vpc."
  sensitive = false  
}

output "default_network_acl_id_of_default_vpc" {
  value = aws_default_vpc.default.default_network_acl_id
}

output "vpc_id" {
  value = aws_vpc.main.id
  description = "The id of the vpc."
  sensitive = false
}

output "default_network_acl_id_of_main_vpc" {
  value = aws_vpc.main.default_network_acl_id
  sensitive = false
}

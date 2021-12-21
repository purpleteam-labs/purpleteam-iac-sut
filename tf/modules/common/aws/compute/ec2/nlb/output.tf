// Copyright (C) 2017-2022 BinaryMist Limited. All rights reserved.

// This file is ancillary to PurpleTeam.

// purpleteam-iac-sut is free software: you can redistribute it and/or modify
// it under the terms of the MIT License.

// purpleteam-iac-sut is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// MIT License for more details.

output "aws_lb_target_groups" {
  value = aws_lb_target_group.sut
  description = "The SUT specific lb target groups."
  sensitive = false
}

output "aws_lb_name" {
  value = aws_lb.sut.name
}

output "aws_lb_arn" {
  value = aws_lb.sut.arn
}

output "aws_lb_dns_name" {
  value = aws_lb.sut.dns_name
}

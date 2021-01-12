// Copyright (C) 2017-2021 BinaryMist Limited. All rights reserved.

// This file is part of purpleteam.

// purpleteam is free software: you can redistribute it and/or modify
// it under the terms of the MIT License.

// purpleteam is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// MIT License for more details.

// Security Groups for ECS instances.
output "sg_ssh_id" {
  value = aws_security_group.ssh_access_list.id
}

output "sg_sut_id" {
  value = aws_security_group.purpleteam_sut.id
}

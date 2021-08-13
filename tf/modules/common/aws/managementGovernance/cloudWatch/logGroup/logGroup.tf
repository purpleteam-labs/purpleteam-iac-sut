// Copyright (C) 2017-2021 BinaryMist Limited. All rights reserved.

// This file is part of PurpleTeam.

// PurpleTeam is free software: you can redistribute it and/or modify
// it under the terms of the MIT License.

// PurpleTeam is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// MIT License for more details.

// Todo: Encrypt logs. Use kms_key_id within the aws_cloudwatch_log_group resources.

resource "aws_cloudwatch_log_group" "pt" {
  name              = var.name
  retention_in_days = var.retention_in_days
}

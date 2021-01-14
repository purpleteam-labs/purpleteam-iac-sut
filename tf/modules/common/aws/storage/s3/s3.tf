// Copyright (C) 2017-2021 BinaryMist Limited. All rights reserved.

// This file is part of purpleteam.

// purpleteam is free software: you can redistribute it and/or modify
// it under the terms of the MIT License.

// purpleteam is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// MIT License for more details.

resource "aws_s3_bucket" "sut_public_keys" {
  bucket = "sut-public-keys"
  acl    = "private"
  // provider?

  logging {
    target_bucket = aws_s3_bucket.sut_public_keys_log_bucket.id
    target_prefix = "log/"
  }

  tags = {
    Name        = "SSH public keys for ec2 instances."
    source      = "iac-contOrc-s3"
  }
}

resource "aws_s3_bucket_object" "sut_public_keys" {
  for_each = var.ec2_instance_public_keys

  key = each.key
  bucket = aws_s3_bucket.sut_public_keys.id
  content = each.value
}

resource "aws_s3_bucket" "sut_public_keys_log_bucket" {
  bucket = "sut-public-keys-log-bucket"
  acl    = "log-delivery-write"
}

resource "aws_s3_bucket_public_access_block" "sut_public_keys" {
  bucket = aws_s3_bucket.sut_public_keys.id
  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

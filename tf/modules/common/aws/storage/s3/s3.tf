resource "aws_s3_bucket" "sut_public_keys" {
  bucket = "sut-public-keys"
  acl    = "private"
  // provider?

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

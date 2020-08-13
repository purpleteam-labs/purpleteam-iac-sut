// Used as depends_on in aws_launch_template of autoscaling.tf
output "aws_s3_bucket_object_sut_public_keys" {
  value = aws_s3_bucket_object.sut_public_keys
}

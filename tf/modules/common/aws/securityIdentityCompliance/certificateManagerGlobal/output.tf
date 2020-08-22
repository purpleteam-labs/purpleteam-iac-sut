output "aws_acm_certificate" {
  value = aws_acm_certificate.global_cert
  sensitive = false
}

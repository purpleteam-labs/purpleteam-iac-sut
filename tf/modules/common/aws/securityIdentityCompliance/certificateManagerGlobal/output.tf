output "aws_acm_certificates" {
  value = aws_acm_certificate.global_cert
  sensitive = false
}

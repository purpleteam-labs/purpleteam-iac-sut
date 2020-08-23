resource "aws_acm_certificate" "global_cert" {
  domain_name       = var.purpleteamlabs_domain_name
  validation_method = "DNS"
  /*
  domain_validation_options = [
    {
      domain_name       = "*.sut.purpleteam-labs.com"
      resource_record_name = "_e0dde8f81cc1bffc894fe326d2fb0bb2.auth."
      resource_record_type = "CNAME"
      resource_record_value = "_6323566844411c14ea39db3c4d131ac6."
    }
  ]
  */

  provider = aws

  tags = {
    Name = "pt-${var.purpose}-cert"
    source = "iac-${var.invoking_root}-certificateManager"
  }

  lifecycle {
    create_before_destroy = true
  }

}

resource "cloudflare_record" "global_validation" {
  zone_id = var.purpleteamlabs_cloudflare_dns_zone_id
  
  name   = aws_acm_certificate.global_cert.domain_validation_options.0.resource_record_name
  type   = aws_acm_certificate.global_cert.domain_validation_options.0.resource_record_type
  // lb url?
  // Fix for cloudflare trailing dot: https://github.com/terraform-providers/terraform-provider-cloudflare/issues/154#issuecomment-439236237
  value  = replace(aws_acm_certificate.global_cert.domain_validation_options.0.resource_record_value, "/[.]$/", "")
  ttl = 1 // 1 == auto
}

resource "aws_acm_certificate_validation" "global_cert" {
  certificate_arn         = aws_acm_certificate.global_cert.arn
  validation_record_fqdns = ["${cloudflare_record.global_validation.hostname}"]
}

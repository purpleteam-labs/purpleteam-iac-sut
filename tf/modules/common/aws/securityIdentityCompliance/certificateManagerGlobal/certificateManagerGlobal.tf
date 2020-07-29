resource "aws_acm_certificate" "global_cert" {
  for_each = var.suts_attributes
  
  domain_name       = "${each.value.purpleteamlabs_sut_cname}.${var.purpleteamlabs_domain_name}"
  validation_method = "DNS"
  /*
  domain_validation_options = [
    {
      domain_name       = "nodegoat.purpleteam-labs.com"
      resource_record_name = "_e0dde8f81cc1bffc894fe326d2fb0bb2.auth."
      resource_record_type = "CNAME"
      resource_record_value = "_6323566844411c14ea39db3c4d131ac6."
    }
  ]
  */

  provider = aws

  tags = {
    Name = "pt-${each.value.purpleteamlabs_sut_cname}-cert"
    source = "iac-${var.invoking_root}-certificateManager"
  }

  lifecycle {
    create_before_destroy = true
  }

}

resource "cloudflare_record" "global_validation" {
  for_each = var.suts_attributes

  zone_id = var.purpleteamlabs_cloudflare_dns_zone_id
  
  name   = aws_acm_certificate.global_cert[each.key].domain_validation_options.0.resource_record_name
  type   = aws_acm_certificate.global_cert[each.key].domain_validation_options.0.resource_record_type
  // lb url?
  // Fix for cloudflare trailing dot: https://github.com/terraform-providers/terraform-provider-cloudflare/issues/154#issuecomment-439236237
  value  = replace(aws_acm_certificate.global_cert[each.key].domain_validation_options.0.resource_record_value, "/[.]$/", "")
  ttl = 1 // 1 == auto
}

resource "aws_acm_certificate_validation" "global_cert" {
  for_each = var.suts_attributes
  certificate_arn         = aws_acm_certificate.global_cert[each.key].arn
  validation_record_fqdns = ["${cloudflare_record.global_validation[each.key].hostname}"]
}

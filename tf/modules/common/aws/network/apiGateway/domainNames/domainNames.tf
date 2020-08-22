resource "aws_api_gateway_domain_name" "sut" {
  certificate_arn = var.api_cert_arn
  domain_name     = "${var.purpleteamlabs_sut_cname}.${var.purpleteamlabs_domain_name}"

  endpoint_configuration {
    types = ["EDGE"]
  }
}

module "cloudFlaredNSRecord" {
  source = "../../../../cloudFlare/dNSRecord"
  purpleteamlabs_cloudflare_dns_zone_id = var.purpleteamlabs_cloudflare_dns_zone_id
  name = var.purpleteamlabs_sut_cname
  content = aws_api_gateway_domain_name.sut.cloudfront_domain_name
}

resource "aws_api_gateway_base_path_mapping" "sut" {
  for_each = var.stage_values

  depends_on = [var.stages]
  
  api_id      = var.aws_api_gateway_rest_api_sut_id
  stage_name  = each.key
  domain_name = aws_api_gateway_domain_name.sut.domain_name
  base_path   = each.key
}

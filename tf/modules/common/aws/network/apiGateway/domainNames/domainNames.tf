// Copyright (C) 2017-2022 BinaryMist Limited. All rights reserved.

// This file is ancillary to PurpleTeam.

// purpleteam-iac-sut is free software: you can redistribute it and/or modify
// it under the terms of the MIT License.

// purpleteam-iac-sut is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// MIT License for more details.

resource "aws_api_gateway_domain_name" "sut" {
  for_each = var.suts_attributes

  certificate_arn = var.api_cert_arn
  domain_name     = "${each.value.name}.${var.purpleteamlabs_sut_cname}.${var.purpleteamlabs_domain_name}"

  endpoint_configuration {
    types = ["EDGE"]
  }
}

module "cloudFlareDnsRecords" {
  source = "../../../../cloudFlare/dNSRecords"
  purpleteamlabs_cloudflare_dns_zone_id = var.purpleteamlabs_cloudflare_dns_zone_id
  name_and_content_keyed_by_sut = {
    for k, v in aws_api_gateway_domain_name.sut:
    k => {
      name = v.domain_name
      content = v.cloudfront_domain_name
    }
  }
}

resource "aws_api_gateway_base_path_mapping" "sut" {
  for_each = var.suts_attributes

  depends_on = [var.stages]
  
  api_id      = var.aws_api_gateway_rest_api_suts[each.key].id
  stage_name  = "one_and_only_stage"
  domain_name = aws_api_gateway_domain_name.sut[each.key].domain_name
  base_path   = ""
}

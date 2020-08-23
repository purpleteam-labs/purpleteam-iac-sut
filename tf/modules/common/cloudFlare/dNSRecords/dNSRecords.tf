resource "cloudflare_record" "pt" {
  for_each = var.name_and_content_keyed_by_sut

  zone_id = var.purpleteamlabs_cloudflare_dns_zone_id
  name = each.value.name
  value = each.value.content
  type = var.type
  ttl = 1 // 1 == auto
  proxied = var.proxied
}

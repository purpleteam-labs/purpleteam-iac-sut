resource "cloudflare_record" "pt" {
  zone_id = var.purpleteamlabs_cloudflare_dns_zone_id
  name = var.name
  value = var.content
  type = var.type
  ttl = 1 // 1 == auto
  proxied = var.proxied
}

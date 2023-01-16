## cloudflare
# Add an IPv4 DNS record pointing to the CloudFront distribution
resource "cloudflare_record" "validation" {
  count = length(module.acm.distinct_domain_names)

  zone_id = var.cloudflare_zone
  name    = element(module.acm.validation_domains, count.index)["resource_record_name"]
  type    = element(module.acm.validation_domains, count.index)["resource_record_type"]
  value   = replace(element(module.acm.validation_domains, count.index)["resource_record_value"], "/.$/", "")
  ttl     = 60
  proxied = false

  allow_overwrite = true
  depends_on      = [module.acm.certificate]
}

resource "cloudflare_record" "domain_record" {
  zone_id = var.cloudflare_zone
  name    = var.site_domain
  type    = "CNAME"
  value   = module.alb.lb_dns_name
  ttl     = var.dns_ttl
  proxied = false

  allow_overwrite = var.dns_allow_overwrite_records
}

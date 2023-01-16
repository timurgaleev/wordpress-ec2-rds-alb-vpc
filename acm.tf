module "acm" {
  source      = "terraform-aws-modules/acm/aws"
  version     = "~> v4.0.1"
  domain_name = var.site_domain
  zone_id     = var.cloudflare_zone

  ##### cloudflare
  create_route53_records  = false
  validation_record_fqdns = cloudflare_record.validation.*.hostname

  tags = var.tags
}

output "route53_zone_id" {
  value = local.zone_id
}

output "app_url_https" {
  value = "https://${var.app_subdomain}.${var.domain_name}"
}

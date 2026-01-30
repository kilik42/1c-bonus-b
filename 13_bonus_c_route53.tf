# Terraform configuration for Route 53 DNS records and ACM certificate
locals {
  app_fqdn = "${var.app_subdomain}.${var.domain_name}"

#   manage_route53_in_terraform = false
#   route53_hosted_zone_id      = "Z0706221214QE8EFTLZCU"

  # If Terraform manages the hosted zone → use resource
  # If not → use provided hosted zone ID
  zone_id = var.route53_hosted_zone_id

}

############################################
# Route 53 Hosted Zone
# this is needed only if manage_route53_in_terraform is true

resource "aws_route53_zone" "main_zone" {
  count = var.manage_route53_in_terraform ? 1 : 0
  name  = var.domain_name
}

# ALIAS record: apex domain → ALB
# I need this so that users can access the app using "tetsuzai-kube.com" (without "app" subdomain)
# in other words, this creates an ALIAS record for the apex domain pointing to the ALB
resource "aws_route53_record" "apex_alias" {
  zone_id = local.zone_id
  name    = var.domain_name        # "tetsuzai-kube.com"
  type    = "A"

  alias {
    name                   = aws_lb.app_alb.dns_name
    zone_id                = aws_lb.app_alb.zone_id
    evaluate_target_health = true
  }
}


# ACM Certificate (DNS validation)


resource "aws_acm_certificate" "app_cert" {
  domain_name       = local.app_fqdn
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}


# DNS validation records

resource "aws_route53_record" "app_cert_dns_records" {
  for_each = {
    for dvo in aws_acm_certificate.app_cert.domain_validation_options :
    dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  zone_id = local.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 300
  records = [each.value.record]
  allow_overwrite = true

    depends_on = [
    aws_acm_certificate.app_cert
  ]
}


# Certificate validation completion

resource "aws_acm_certificate_validation" "app_cert_validation" {
  certificate_arn = aws_acm_certificate.app_cert.arn
  validation_record_fqdns = [
    for r in aws_route53_record.app_cert_dns_records : r.fqdn
  ]
}


# ALIAS record: app → ALB

resource "aws_route53_record" "app_alias" {
  zone_id = local.zone_id
  name    = local.app_fqdn
  type    = "A"

  alias {
    name                   = aws_lb.app_alb.dns_name
    zone_id                = aws_lb.app_alb.zone_id
    evaluate_target_health = true
  }
}

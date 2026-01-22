# Public hosted zone for your domain
resource "aws_route53_zone" "app_zone" {
  name = var.domain_name
}

# ACM certificate for app.<domain>
resource "aws_acm_certificate" "app_cert" {
  domain_name       = "${var.app_subdomain}.${var.domain_name}"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# DNS validation record for ACM
resource "aws_route53_record" "app_cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.app_cert.domain_validation_options :
    dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  zone_id = aws_route53_zone.app_zone.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 60
  records = [each.value.record]
}

# ACM waits until DNS validation succeeds
resource "aws_acm_certificate_validation" "app_cert_validation_complete" {
  certificate_arn         = aws_acm_certificate.app_cert.arn
  validation_record_fqdns = [for r in aws_route53_record.app_cert_validation : r.fqdn]
}

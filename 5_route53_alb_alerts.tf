# order of resources  
# 1. route53_alb_alerts.tf
# 2. sns_topics.tf
# 3. variables.tf
# 4. locals.tf
# 5. bonus_b_outputs.tf

# Route53 + ACM (DNS validation) + ALB Alerts for Chewbacca Application
# 1c_bonus_b/route53_alb_alerts.tf
# Create Route53 record for Chewbacca ALB

resource "aws_route53_zone" "chewbacca_zone" {
  name = var.chewbacca_domain_name
}

# Create ACM certificate for Chewbacca application with DNS validation
# ALB requires a valid SSL/TLS certificate for HTTPS listeners
# We will use AWS Certificate Manager (ACM) to create the certificate
# and validate it using DNS validation via Route53
resource "aws_acm_certificate" "chewbacca_cert" {
  domain_name       = "${var.chewbacca_app_subdomain}.${var.chewbacca_domain_name}"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# Create Route53 record for ACM DNS validation
# This record is required to validate the ACM certificate
resource "aws_route53_record" "chewbacca_cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.chewbacca_cert.domain_validation_options :
    dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

 # we need to refer to the hosted zone id created above
 # this is how route53 knows which domain to create the record in
  zone_id = aws_route53_zone.chewbacca_zone.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 60
  records = [each.value.record]
}

# Validate the ACM certificate using the DNS records created above
# This resource ensures that the certificate is only considered valid
# after the DNS validation records have been created
resource "aws_acm_certificate_validation" "chewbacca_cert_validation_complete" {
  certificate_arn         = aws_acm_certificate.chewbacca_cert.arn
  validation_record_fqdns = [for r in aws_route53_record.chewbacca_cert_validation : r.fqdn]
}
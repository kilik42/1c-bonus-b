# Public hosted zone for your domain
# Assumes the domain is already registered and managed in Route 53
#This tells Route 53:“Host DNS for my domain (like example.com).”
# data "aws_route53_zone" "app_zone" {
#   name         = var.domain_name
#   private_zone = false
# }

# ACM certificate for app, validated via DNS
# This says:
# “AWS, please create an SSL certificate for app.example.com, and I’ll prove ownership using DNS.”
# resource "aws_acm_certificate" "app_cert" {
#   domain_name       = "${var.app_subdomain}.${var.domain_name}"
#   validation_method = "DNS"

#   lifecycle {
#     create_before_destroy = true
#   }
# }

# DNS validation record for ACM
# This part says:
# “Create the exact DNS record ACM told me to create.”

# Terraform loops through ACM’s validation options and builds the DNS record automatically.

# This is the magic that avoids copy‑pasting DNS records manually.
# resource "aws_route53_record" "app_cert_validation" {
#   for_each = {
#     for dvo in aws_acm_certificate.app_cert.domain_validation_options :
#     dvo.domain_name => {
#       name   = dvo.resource_record_name
#       type   = dvo.resource_record_type
#       record = dvo.resource_record_value
#     }
#   }

#   name            = each.value.name
#   type            = each.value.type
#   zone_id         = var.route53_hosted_zone_id
#   records         = [each.value.record]
#   ttl             = 300
#   allow_overwrite = true
# }


# ACM waits until DNS validation succeeds
# This says:
# “ACM, here are the DNS records I created. Keep checking until they validate.”

# Terraform won’t continue until ACM confirms the certificate is issued.
# resource "aws_acm_certificate_validation" "app_cert_validation_complete" {
#   certificate_arn         = aws_acm_certificate.app_cert.arn
#   validation_record_fqdns = [for r in aws_route53_record.app_cert_validation : r.fqdn]
# }

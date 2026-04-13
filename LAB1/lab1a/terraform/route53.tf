# Look up the existing hosted zone for the root domain.
# I already own/manage this zone in Route53, so I am reusing it instead of creating a new one.
data "aws_route53_zone" "main" {
  name         = var.domain_name
  private_zone = false
}

# Apex alias record pointing the root domain to the ALB.
# This keeps the main domain as the direct ALB entry point for Lab 1A.
resource "aws_route53_record" "apex_alias" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_lb.app_alb.dns_name
    zone_id                = aws_lb.app_alb.zone_id
    evaluate_target_health = true
  }
}
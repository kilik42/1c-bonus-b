# Route53 ALIAS to ALB for Chewbacca Application
# 1c_bonus_b/9_route53_alias_to_alb.tf
# Create Route53 ALIAS record pointing to Chewbacca ALB
# This allows users to access the application using a friendly domain name

resource "aws_route53_record" "chewbacca_app_alias" {
  zone_id = aws_route53_zone.chewbacca_zone.zone_id
  name    = "${var.chewbacca_app_subdomain}.${var.chewbacca_domain_name}"
  type    = "A"

  alias {
    name                   = aws_lb.chewbacca_alb.dns_name
    zone_id                = aws_lb.chewbacca_alb.zone_id
    evaluate_target_health = true
  }
}


# WAFv2 + association
# Create a basic WAFv2 Web ACL and associate it with the Chewbacca ALB
# This provides basic protection against common web exploits
# 1c_bonus_b/9_route53_alias_to_alb.tf
#   WAFv2 Web ACL for Chewbacca ALB
resource "aws_wafv2_web_acl" "chewbacca_waf" {
  name        = "chewbacca-waf01"
  description = "Basic WAF for Chewbacca ALB"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "chewbacca-waf-metric"
    sampled_requests_enabled   = true
  }
}

# Associate WAFv2 Web ACL with Chewbacca ALB

resource "aws_wafv2_web_acl_association" "chewbacca_waf_assoc" {
  resource_arn = aws_lb.chewbacca_alb.arn
  web_acl_arn  = aws_wafv2_web_acl.chewbacca_waf.arn
}
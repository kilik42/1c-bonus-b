# Route53 ALIAS record pointing to the ALB
# resource "aws_route53_record" "app_alias" {
#   zone_id = data.aws_route53_zone.app_zone.zone_id
#   name    = "${var.app_subdomain}.${var.domain_name}"
#   type    = "A"

#   alias {
#     name                   = aws_lb.app_alb.dns_name
#     zone_id                = aws_lb.app_alb.zone_id
#     evaluate_target_health = true
#   }
# }

# WAFv2 Web ACL for the ALB
resource "aws_wafv2_web_acl" "app_waf" {
  name        = "tetsuzai-waf01"
  description = "Basic WAF for tetsuzai ALB"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "tetsuzai-waf-metric"
    sampled_requests_enabled   = true
  }
}

# Associate WAFv2 Web ACL with the ALB
resource "aws_wafv2_web_acl_association" "app_waf_assoc" {
  resource_arn = aws_lb.app_alb.arn
  web_acl_arn  = aws_wafv2_web_acl.app_waf.arn
}
# Route53 ALIAS record pointing to CloudFront (Lab 2)
# Route53 ALIAS record pointing to CloudFront (Lab 2)
resource "aws_route53_record" "app_alias" {
  zone_id = local.zone_id
  name    = "${var.app_subdomain}.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.tetsuzai_cf.domain_name
    zone_id                = aws_cloudfront_distribution.tetsuzai_cf.hosted_zone_id
    evaluate_target_health = false
  }
}
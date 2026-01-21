output "chewbacca_alb_dns_name" {
  description = "Public DNS name of the Chewbacca ALB"
  value       = aws_lb.chewbacca_alb.dns_name
}

output "chewbacca_app_url" {
  description = "HTTPS URL for the app"
  value       = "https://${var.chewbacca_app_subdomain}.${var.chewbacca_domain_name}"
}

output "chewbacca_waf_arn" {
  description = "WAF Web ACL ARN"
  value       = aws_wafv2_web_acl.chewbacca_waf.arn
}

output "chewbacca_dashboard_name" {
  description = "CloudWatch dashboard name"
  value       = aws_cloudwatch_dashboard.chewbacca_dashboard.dashboard_name
}

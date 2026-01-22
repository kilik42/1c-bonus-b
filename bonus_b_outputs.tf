output "app_alb_dns_name" {
  description = "Public DNS name of the ALB"
  value       = aws_lb.app_alb.dns_name
}

output "app_url" {
  description = "HTTPS URL for the application"
  value       = "https://${var.app_subdomain}.${var.domain_name}"
}

output "app_waf_arn" {
  description = "WAF Web ACL ARN"
  value       = aws_wafv2_web_acl.app_waf.arn
}

output "app_dashboard_name" {
  description = "CloudWatch dashboard name"
  value       = aws_cloudwatch_dashboard.app_dashboard.dashboard_name
}

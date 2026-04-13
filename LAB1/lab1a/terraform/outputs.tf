# VPC ID for quick reference during validation and troubleshooting.
output "vpc_id" {
  description = "VPC ID for Lab 1A"
  value       = aws_vpc.lab1_vpc.id
}

# Public subnets used by the ALB.
output "public_subnet_ids" {
  description = "Public subnet IDs used by the ALB"
  value = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id
  ]
}

# Private DB subnets used by the RDS subnet group.
output "private_db_subnet_ids" {
  description = "Private DB subnet IDs"
  value = [
    aws_subnet.private_db_a.id,
    aws_subnet.private_db_b.id
  ]
}

# EC2 instance ID for the Flask app host.
output "app_instance_id" {
  description = "EC2 instance ID for the app server"
  value       = aws_instance.app_server.id
}

# ALB DNS name for direct testing before/alongside Route53 propagation.
output "alb_dns_name" {
  description = "ALB DNS name"
  value       = aws_lb.app_alb.dns_name
}

# Main app URL using the Route53 apex domain.
output "app_url" {
  description = "Primary application URL"
  value       = "http://${var.domain_name}"
}

# Database endpoint for verification purposes.
# The app itself should use Secrets Manager, but this is useful for checks/debugging.
output "rds_endpoint" {
  description = "RDS endpoint address"
  value       = aws_db_instance.lab1_db.address
}

# Secret name the app reads at runtime.
output "db_secret_name" {
  description = "Secrets Manager secret name"
  value       = aws_secretsmanager_secret.db_secret.name
}

# IAM role used by the app instance.
output "app_role_name" {
  description = "IAM role name attached to the app instance"
  value       = aws_iam_role.app_role.name
}

# Instance profile attached to the EC2 instance.
output "app_instance_profile_name" {
  description = "IAM instance profile attached to the app server"
  value       = aws_iam_instance_profile.app_instance_profile.name
}
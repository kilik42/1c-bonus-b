variable "domain_name" {
  description = "Root domain for the application"
  type        = string
  default     = "tetsuzai-kube.com"
}

variable "app_subdomain" {
  description = "Subdomain for the application endpoint"
  type        = string
  default     = "app"
}

variable "app_port" {
  description = "Port the application listens on"
  type        = number
  default     = 80
}

variable "aws_region" {
  description = "AWS region for all resources"
  type        = string
  default     = "us-west-2"
}

variable "instance_type" {
  description = "EC2 instance type for the application"
  type        = string
  default     = "t3.micro"
}

# Variable to control whether to create/manage Route53 hosted zone and records in Terraform
variable "manage_route53_in_terraform" {
  description = "If true, create/manage Route53 hosted zone + records in Terraform."
  type        = bool
  default     = true
}

# Variable to provide existing Route53 hosted zone ID if not managing in Terraform
variable "route53_hosted_zone_id" {
  description = "If manage_route53_in_terraform=false, provide existing Hosted Zone ID for domain."
  type        = string
  default     = ""
}

# Variable to provide existing ACM certificate ARN if not creating in Terraform
variable "certificate_arn" {
  description = "ARN of the ACM certificate for the domain"
  type        = string
  default     = ""
}

## adding logging variables
# Variable to enable/disable ALB access logging
variable "enable_alb_access_logs" {
  description = "Enable ALB access logging to S3."
  type        = bool
  default     = true
}

# Variable for S3 bucket prefix for ALB access logs
variable "alb_access_logs_prefix" {
  description = "S3 prefix for ALB access logs."
  type        = string
  default     = "alb-access-logs"
}



# Main AWS region for this lab build.
# Keeping it variable-driven makes it easier to move later if needed.
variable "aws_region" {
  description = "AWS region for Lab 1 deployment"
  type        = string
  default     = "us-west-2"
}

# Base prefix used for naming/tagging resources.
# Helps keep the console organized and makes the lab easier to identify.
variable "project_name" {
  description = "Base name/prefix for resources"
  type        = string
  default     = "lab1-redone"
}

# Existing Route53 hosted zone that will point to the ALB later.
# I already own/manage this domain in AWS.
variable "domain_name" {
  description = "Root Route53 domain already hosted in AWS"
  type        = string
  default     = "tetsuzai-kube.com"
}

# Internal application port for the Flask notes app.
# ALB will forward traffic here from port 80/443.
variable "app_port" {
  description = "Port the Flask app listens on"
  type        = number
  default     = 5000
}

# Small instance is enough for this lab/demo workload.
# Can scale up later if needed.
variable "instance_type" {
  description = "EC2 instance type for app host"
  type        = string
  default     = "t3.micro"
}

# Database name used by the Flask notes application.
variable "db_name" {
  description = "Application database name"
  type        = string
  default     = "notesdb"
}

# Master DB username for the RDS instance.
# Password will be generated/stored separately in Secrets Manager.
variable "db_username" {
  description = "Master DB username"
  type        = string
  default     = "admin"
}

# Standard MySQL port for the RDS instance.
variable "db_port" {
  description = "RDS MySQL port"
  type        = number
  default     = 3306
}

# Email used for SNS notifications in Lab 1B.
# Placeholder for now until monitoring is added.
variable "notification_email" {
  description = "Email for SNS alerts in Lab 1B"
  type        = string
  default     = "your-email@example.com"
}

# CIDR range for the main lab VPC.
# Using a dedicated /16 so subnetting stays flexible later.
variable "vpc_cidr" {
  description = "CIDR block for main VPC"
  type        = string
  default     = "10.10.0.0/16"
}
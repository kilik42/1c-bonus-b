# AWS region for the São Paulo satellite compute stack.
variable "aws_region" {
  description = "AWS region for the São Paulo secondary region"
  type        = string
  default     = "sa-east-1"
}

# Base project name used for naming and tagging resources.
variable "project_name" {
  description = "Base name for LAB3 resources"
  type        = string
  default     = "lab3-saopaulo"
}

# Logical label for the primary region side of the architecture.
# In this portfolio adaptation, the existing us-west-2 stack is treated conceptually as Tokyo.
variable "primary_region_label" {
  description = "Logical label for the primary data-authority region"
  type        = string
  default     = "tokyo-primary"
}

# Main VPC CIDR for the São Paulo region.
variable "vpc_cidr" {
  description = "CIDR block for the São Paulo VPC"
  type        = string
  default     = "10.30.0.0/16"
}

# Public subnet A for São Paulo ALB ingress.
variable "public_subnet_a_cidr" {
  description = "CIDR for São Paulo public subnet A"
  type        = string
  default     = "10.30.1.0/24"
}

# Public subnet B for São Paulo ALB ingress.
variable "public_subnet_b_cidr" {
  description = "CIDR for São Paulo public subnet B"
  type        = string
  default     = "10.30.2.0/24"
}

# Private application subnet A for São Paulo compute.
variable "private_app_subnet_a_cidr" {
  description = "CIDR for São Paulo private app subnet A"
  type        = string
  default     = "10.30.10.0/24"
}

# Private application subnet B for São Paulo compute.
variable "private_app_subnet_b_cidr" {
  description = "CIDR for São Paulo private app subnet B"
  type        = string
  default     = "10.30.11.0/24"
}

# Port used by the application service.
variable "app_port" {
  description = "Application port for the São Paulo app tier"
  type        = number
  default     = 5000
}

# EC2 instance type for the São Paulo application hosts.
variable "instance_type" {
  description = "Instance type for São Paulo app servers"
  type        = string
  default     = "t3.micro"
}

# The Transit Gateway ID for the logical primary region is needed in the secondary region to create the peering attachment, so we declare a variable for it here to be populated from the primary region's outputs.
variable "primary_tgw_id" {
  description = "Transit Gateway ID for the logical primary region"
  type        = string
}


# The TGW attachment ID for the primary VPC is needed in the secondary region to create the peering attachment, so we declare a variable for it here to be populated from the primary region's outputs.
variable "primary_vpc_cidr" {
  description = "CIDR for the logical primary VPC"
  type        = string
  default     = "10.10.0.0/16"
}
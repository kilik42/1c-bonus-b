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

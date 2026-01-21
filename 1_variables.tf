variable "chewbacca_domain_name" {
  type    = string
  default = "chewbacca-growl.com"
}

variable "chewbacca_app_subdomain" {
  type    = string
  default = "app"
}

variable "chewbacca_app_port" {
  type    = number
  default = 80
}

variable "aws_region" {
  type    = string
  default = "us-west-2"
}
variable "instance_type" {
  type    = string
  default = "t3.micro"
}
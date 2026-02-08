variable "db_username" {
  type        = string
  description = "Username for Tokyo RDS"
}

variable "db_password" {
  type        = string
  description = "Password for Tokyo RDS"
}

variable "saopaulo_vpc_cidr" {
  type        = string
  description = "CIDR block of the Sao Paulo VPC"
}

variable "saopaulo_tgw_id" {
  type        = string
  description = "Transit Gateway ID from Sao Paulo"
}

variable "saopaulo_account_id" {
  type        = string
  description = "AWS account ID for Sao Paulo region"
}

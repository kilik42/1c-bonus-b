terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.28"
    }
  }
}

# provider "aws" {
#   region = "sa-east-1"
# }
provider "aws" {
  region = "ap-northeast-1"
}

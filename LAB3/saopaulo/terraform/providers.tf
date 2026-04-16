terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Primary provider for the São Paulo satellite compute region.
# LAB3A deploys the secondary stateless application stack here.
provider "aws" {
  region = var.aws_region
}
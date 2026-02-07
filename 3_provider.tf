terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.28.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# provider for us-east-2 region
provider "aws" {
  alias  = "east"
  region = var.aws_region_east
}

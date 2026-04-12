provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project   = local.project_name
      Lab       = "lab1a"
      ManagedBy = "terraform"
    }
  }
}
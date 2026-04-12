# Shared local values used across the lab.
# This keeps naming/tagging consistent without repeating string formatting everywhere.
locals {

  # Main resource prefix used for most AWS resources.
  # Helps keep naming predictable across EC2, RDS, ALB, etc.
  project_name = var.project_name

  # Common tags applied manually where needed.
  # Provider-level default tags handle most resources, but this is useful for exceptions.
  common_tags = {
    Project   = local.project_name
    Lab       = "lab1a"
    ManagedBy = "terraform"
  }

  # Full app URL for convenience/output later.
  # This will eventually point to the ALB via Route53.
  app_url = "http://${var.domain_name}"
}
# Random password for the RDS master user.
# This keeps the DB password out of the Terraform code and makes the lab safer to reuse.
resource "random_password" "db_password" {
  length           = 20
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# Secrets Manager container for the database credentials.
# The app will read this at runtime using its EC2 IAM role.
resource "aws_secretsmanager_secret" "db_secret" {
  name        = "${local.project_name}/rds/mysql"
  description = "Database credentials for the Lab 1 Flask notes app"

  tags = merge(local.common_tags, {
    Name = "${local.project_name}-db-secret"
  })
}

# Actual secret value stored as JSON.
# This matches the structure the Flask app expects when it calls Secrets Manager.
resource "aws_secretsmanager_secret_version" "db_secret_value" {
  secret_id = aws_secretsmanager_secret.db_secret.id

  secret_string = jsonencode({
    username = var.db_username
    password = random_password.db_password.result
    host     = aws_db_instance.lab1_db.address
    port     = var.db_port
    dbname   = var.db_name
  })
}
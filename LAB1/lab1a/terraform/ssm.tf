# Store the database endpoint in Parameter Store.
# I am keeping non-secret connection details here so the app environment has a clean config source.
resource "aws_ssm_parameter" "db_endpoint" {
  name  = "/${local.project_name}/db/endpoint"
  type  = "String"
  value = aws_db_instance.lab1_db.address

  tags = merge(local.common_tags, {
    Name = "${local.project_name}-db-endpoint-param"
  })
}

# Store the database port in Parameter Store.
# This stays separate from Secrets Manager because it is configuration, not a credential.
resource "aws_ssm_parameter" "db_port" {
  name  = "/${local.project_name}/db/port"
  type  = "String"
  value = tostring(var.db_port)

  tags = merge(local.common_tags, {
    Name = "${local.project_name}-db-port-param"
  })
}

# Store the database/schema name in Parameter Store.
# This gives the environment a reusable place to look up the target DB name.
resource "aws_ssm_parameter" "db_name" {
  name  = "/${local.project_name}/db/name"
  type  = "String"
  value = var.db_name

  tags = merge(local.common_tags, {
    Name = "${local.project_name}-db-name-param"
  })
}
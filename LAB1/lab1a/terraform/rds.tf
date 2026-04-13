# Subnet group for the RDS instance.
# RDS needs subnet placement across at least two AZs, so I am using both private DB subnets here.
resource "aws_db_subnet_group" "lab1_db_subnet_group" {
  name = "${local.project_name}-db-subnet-group"

  subnet_ids = [
    aws_subnet.private_db_a.id,
    aws_subnet.private_db_b.id
  ]

  tags = merge(local.common_tags, {
    Name = "${local.project_name}-db-subnet-group"
  })
}

# Main MySQL database for the Flask notes app.
# This stays private and only accepts traffic from the app security group.
resource "aws_db_instance" "lab1_db" {
  identifier = "${local.project_name}-mysql"

  engine         = "mysql"
  engine_version = "8.0"

  instance_class = "db.t3.micro"

  allocated_storage     = 20
  max_allocated_storage = 100
  storage_type          = "gp3"
  storage_encrypted     = true

  # The DB credentials are not hardcoded here; instead, the password is generated randomly and stored securely in Secrets Manager. This is a best practice for managing secrets and keeps our Terraform code clean.
  db_name  = var.db_name
  username = var.db_username
  password = random_password.db_password.result
  port     = var.db_port

  # RDS needs to be placed in subnets and security groups that allow it to communicate with the app, but we don't want it exposed to the public internet. This keeps the DB secure and only accessible by our app.
  db_subnet_group_name = aws_db_subnet_group.lab1_db_subnet_group.name


  # The security group allows inbound MySQL traffic from the app security group, but blocks all other access. This is a critical part of our network security design for the lab.
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  # For a lab environment, we can keep the DB simple and avoid extra costs by not enabling multi-AZ or public access. In production, you'd want to consider high availability and proper backup strategies.
  publicly_accessible = false # we do not want the DB to be accessible from the public internet, only from our app within the VPC. This is a key security measure to protect our database.
  multi_az            = false

  skip_final_snapshot = true
  deletion_protection = false

  backup_retention_period = 0

  apply_immediately = true

  tags = merge(local.common_tags, {
    Name = "${local.project_name}-mysql"
  })
}
# Look up a current Amazon Linux 2023 AMI.
# Using a data source here avoids hardcoding an image ID that might go stale later.
data "aws_ami" "amazon_linux_2023" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

# EC2 instance that runs the Flask notes app.
# For the first pass, I am placing it in a public subnet so package installs/user-data work cleanly.
# The intended traffic path is still ALB -> app instance -> RDS.
resource "aws_instance" "app_server" {
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_a.id
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  # The IAM instance profile allows the EC2 instance to assume the app_role, which has permissions to read the DB secret from Secrets Manager. This is crucial for the app to connect to the RDS database without hardcoding credentials.
  iam_instance_profile = aws_iam_instance_profile.app_instance_profile.name

  associate_public_ip_address = true

  user_data = templatefile("${path.module}/../app/user_data.sh", {
    aws_region = var.aws_region
    secret_id  = aws_secretsmanager_secret.db_secret.name
    app_port   = var.app_port
  })

  tags = merge(local.common_tags, {
    Name = "${local.project_name}-app-server"
  })
}
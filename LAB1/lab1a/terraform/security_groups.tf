
# so this is going from the internet, then alb security group, ec2 app security group, then RDS security group. Only the ALB SG is exposed to the internet, and the app SG can only be reached from the ALB SG, and the RDS SG can only be reached from the app SG. 

# 1_INTERNET -> 2_ALB_SG -> 3_APP_SG -> 4_RDS_SG (Process so i dont forget)
# Security group for the public-facing ALB.
# This is the only resource intentionally exposed to the internet.
resource "aws_security_group" "alb_sg" {
  name        = "${local.project_name}-alb-sg"
  description = "ALB security group"
  vpc_id      = aws_vpc.lab1_vpc.id

  # Ingress rules allow HTTP and HTTPS traffic from anywhere.
  ingress {
    description = "Allow HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Future-proofing for TLS support by allowing HTTPS traffic as well.
  #use 443 for HTTPS, but we will set up the ALB to listen on 80 for this lab.
  ingress {
    description = "Allow HTTPS from internet (future TLS support)"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Egress rule allows all outbound traffic from the ALB to reach the app servers.
  egress {
    description = "Allow outbound to app targets"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "${local.project_name}-alb-sg"
  })
}

# Security group for the Flask app EC2 instance.
# Only the ALB should be able to reach the app directly.
resource "aws_security_group" "app_sg" {
  name        = "${local.project_name}-app-sg"
  description = "App EC2 security group"
  vpc_id      = aws_vpc.lab1_vpc.id

  ingress {
    description     = "Allow app traffic from ALB only"
    from_port       = var.app_port
    to_port         = var.app_port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    description = "Allow outbound for package installs / AWS API access"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "${local.project_name}-app-sg"
  })
}

# Security group for the RDS MySQL instance.
# Database access is restricted strictly to the app SG.
resource "aws_security_group" "rds_sg" {
  name        = "${local.project_name}-rds-sg"
  description = "RDS security group"
  vpc_id      = aws_vpc.lab1_vpc.id

  ingress {
    description     = "Allow MySQL from app tier only"
    from_port       = var.db_port
    to_port         = var.db_port
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }

  egress {
    description = "Allow outbound if needed"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "${local.project_name}-rds-sg"
  })
}
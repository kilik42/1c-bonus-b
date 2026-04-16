# Security group for the São Paulo public-facing ALB.
# This is the only internet-facing entry point in the secondary region.
resource "aws_security_group" "alb_sg" {
  name        = "${local.project_name}-alb-sg"
  description = "ALB security group for São Paulo ingress"
  vpc_id      = aws_vpc.saopaulo_vpc.id

  ingress {
    description = "Allow HTTP from the internet"
    # For simplicity, we're allowing all IPv4 traffic on port 80. In a production environment, I might want to restrict this further or use HTTPS with a certificate.
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow outbound traffic to application targets"
    # For the ALB, we need to allow it to reach the application instances on the app port. However, since the app security group will allow traffic from the ALB security group, we can allow all outbound traffic here for simplicity.
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "${local.project_name}-alb-sg"
  })
}

# Security group for the São Paulo application tier.
# Only the ALB should be able to reach the app directly.
resource "aws_security_group" "app_sg" {
  name        = "${local.project_name}-app-sg"
  description = "Application security group for São Paulo compute"
  vpc_id      = aws_vpc.saopaulo_vpc.id

  ingress {
    description     = "Allow app traffic from São Paulo ALB only"
    from_port       = var.app_port
    to_port         = var.app_port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    description = "Allow outbound traffic from application tier"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "${local.project_name}-app-sg"
  })
}
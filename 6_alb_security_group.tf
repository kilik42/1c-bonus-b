resource "aws_security_group" "alb_sg" {
  name        = "tetsuzai-alb-sg"
  description = "ALB security group for tetsuzai app"
  vpc_id      = local.vpc_id

  # Allow HTTP from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTPS from anywhere
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow outbound traffic to EC2 on app port
  egress {
    from_port       = var.app_port
    to_port         = var.app_port
    protocol        = "tcp"
    security_groups = [local.ec2_sg_id]
  }

  tags = {
    Name = "tetsuzai-alb-sg"
  }
}

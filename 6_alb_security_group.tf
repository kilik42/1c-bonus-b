# ALB security group
resource "aws_security_group" "chewbacca_alb_sg" {
  name        = "chewbacca-alb-sg"
  description = "ALB SG for Chewbacca app"
  vpc_id      = local.chewbacca_vpc_id

# Allow HTTP and HTTPS from anywhere
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

# Allow traffic to EC2 instance on app port
  egress {
    from_port       = var.chewbacca_app_port
    to_port         = var.chewbacca_app_port
    protocol        = "tcp"
    security_groups = [local.chewbacca_ec2_sg_id]
  }

# Allow all outbound traffic
  tags = {
    Name = "chewbacca-alb-sg"
  }
}
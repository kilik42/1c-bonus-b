
# Target group + ALB for Chewbacca application
# 1c_bonus_b/7_target_group_alb.tf


resource "aws_lb_target_group" "chewbacca_tg" {
  # this is target group for chewbacca app
  name     = "chewbacca-tg01"
  # this is http because our app listens on http
  port     = var.chewbacca_app_port
  protocol = "HTTP"
  vpc_id   = local.chewbacca_vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 2
  }
}

# Create Application Load Balancer for Chewbacca application
# ALB will distribute incoming traffic to the EC2 instance
resource "aws_lb" "chewbacca_alb" {
  name               = "chewbacca-alb01"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.chewbacca_alb_sg.id]
  subnets            = local.chewbacca_public_subnets

  tags = {
    Name = "chewbacca-alb01"
  }
}

resource "aws_lb_target_group_attachment" "chewbacca_tg_attachment" {
  target_group_arn = aws_lb_target_group.chewbacca_tg.arn
  target_id        = local.chewbacca_ec2_instance_id
  port             = var.chewbacca_app_port
}
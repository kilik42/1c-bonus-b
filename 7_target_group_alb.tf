# Target group for tetsuzai app
resource "aws_lb_target_group" "app_tg" {
  name     = "tetsuzai-tg01"
  port     = var.app_port
  protocol = "HTTP"
  vpc_id   = local.vpc_id

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

# Application Load Balancer for tetsuzai app
resource "aws_lb" "app_alb" {
  name               = "tetsuzai-alb01"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = local.public_subnets

  tags = {
    Name = "tetsuzai-alb01"
  }
}

# Attach EC2 instance to target group
resource "aws_lb_target_group_attachment" "app_tg_attachment" {
  target_group_arn = aws_lb_target_group.app_tg.arn
  target_id        = local.ec2_instance_id
  port             = var.app_port
}

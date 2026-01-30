# creating a target group, creating a public ALB, and attaching your EC2 instance so the ALB can route traffic to your app with health checks.
# # Target group for tetsuzai app
resource "aws_lb_target_group" "app_tg" {
  name     = "tetsuzai-tg01"
  port     = var.app_port
  protocol = "HTTP"
  vpc_id   = local.vpc_id


  #   This tells AWS:
  # “Check the app at / every 30 seconds.”
  # “If it returns a status between 200–399, it’s healthy.”
  # “If it fails twice, mark it unhealthy.”
  # “If it succeeds three times, mark it healthy again.”
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
# This creates a public-facing ALB (because internal = false).
# It lives in my public subnets
# It uses the ALB security group
# It will later get listeners (HTTP/HTTPS) that forward traffic to the target group
# This is the thing users hit when they visit my domain.
resource "aws_lb" "app_alb" {
  name               = "tetsuzai-alb01"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = local.public_subnets

  # Enable access logging if specified
  access_logs {
    bucket  = aws_s3_bucket.alb_logs[0].bucket
    prefix  = var.alb_access_logs_prefix
    enabled = var.enable_alb_access_logs
  }
  tags = {
    Name = "tetsuzai-alb01"
  }
}

# Attach EC2 instance to target group
# This says:

# “Add my EC2 instance to the target group so the ALB can send it traffic.”
resource "aws_lb_target_group_attachment" "app_tg_attachment" {
  target_group_arn = aws_lb_target_group.app_tg.arn
  target_id        = local.ec2_instance_id
  port             = var.app_port
}

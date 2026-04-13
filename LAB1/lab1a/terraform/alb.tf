# Public-facing Application Load Balancer for the app.
# This is the only intended internet-facing entry point for Lab 1A.
resource "aws_lb" "app_alb" {
  name               = "${local.project_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]

  subnets = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id
  ]

  enable_deletion_protection = false # Deletion protection can be a pain during iterative development, so I'm leaving it off for the lab. In production, you would likely want this enabled to prevent accidental deletion of the ALB.

  tags = merge(local.common_tags, {
    Name = "${local.project_name}-alb"
  })
}

# Target group for the Flask app instances.
# The ALB forwards traffic here, and the target group checks app health on port 5000.
resource "aws_lb_target_group" "app_tg" {
  name        = "${local.project_name}-tg"
  port        = var.app_port
  protocol    = "HTTP"
  vpc_id      = aws_vpc.lab1_vpc.id
  target_type = "instance"

  health_check {
    enabled             = true
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }


  # Adding tags to the target group for better organization and cost allocation. This also helps when viewing resources in the AWS console, as you can easily identify which target group belongs to this lab.
  tags = merge(local.common_tags, {
    Name = "${local.project_name}-tg"
  })
}

# Register the EC2 app instance with the target group.
# Right now there is only one app host, but this keeps the ALB path realistic.
resource "aws_lb_target_group_attachment" "app_attach" {
  target_group_arn = aws_lb_target_group.app_tg.arn
  target_id        = aws_instance.app_server.id
  port             = var.app_port
}

# HTTP listener for the ALB.
# Starting with plain HTTP keeps the first end-to-end test simpler.
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}
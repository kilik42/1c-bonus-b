# Public-facing ALB for the São Paulo secondary region.
# This gives the satellite compute region its own ingress layer instead of reusing the primary ALB.
resource "aws_lb" "saopaulo_alb" {
  name               = "${local.project_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]

  subnets = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id
  ]

  enable_deletion_protection = false

  tags = merge(local.common_tags, {
    Name = "${local.project_name}-alb"
  })
}

# Target group for the São Paulo application tier.
# Health checks will use the app root path so the ALB can determine if the service is alive.
resource "aws_lb_target_group" "app_tg" {
  name        = "${local.project_name}-tg"
  port        = var.app_port
  protocol    = "HTTP"
  vpc_id      = aws_vpc.saopaulo_vpc.id
  target_type = "instance"

  health_check {
    enabled = true
    # For simplicity, we're using HTTP on the app port with a basic 200 response matcher. In a production environment, I might want to use HTTPS and a more specific health check path. 
    path                = "/" # Assuming the app serves a basic page at the root that returns 200 when healthy.
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }

  tags = merge(local.common_tags, {
    Name = "${local.project_name}-tg"
  })
}

# HTTP listener for the São Paulo ALB.
# Keeping this simple for the first pass so the region can be tested before adding more edge/security layers.
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.saopaulo_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}
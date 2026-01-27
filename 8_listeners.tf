
# Listeners for Application Load Balancer for Chewbacca application
# 1c_bonus_b/8_listeners.tf
# Create HTTP listener on port 80 that redirects to HTTPS
# we need to create listeners for our ALB to handle incoming traffic

# HTTP listener: redirect all traffic to HTTPS
resource "aws_lb_listener" "app_http_listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# HTTPS listener: terminate TLS and forward to target group
# resource "aws_lb_listener" "app_https_listener" {
#   load_balancer_arn = aws_lb.app_alb.arn
#   port              = 443
#   protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   certificate_arn   = aws_acm_certificate_validation.app_cert_validation_complete.certificate_arn

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.app_tg.arn
#   }
# }

# Updated HTTPS listener with TLS 1.3 support

# HTTPS listener: terminate TLS and forward to target group
resource "aws_lb_listener" "app_https_listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = aws_acm_certificate.app_cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }

  depends_on = [
    aws_acm_certificate_validation.app_cert_validation
  ]
}


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

# Add secret header requirement to ALB listener

resource "aws_lb_listener_rule" "require_secret_header" {
  listener_arn = aws_lb_listener.app_https_listener.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }

  condition {
    http_header {
      http_header_name = "X-Secret-Header"
      values           = ["OpenSesame"]
    }
  }
}

# Default rule to return 403 if secret header is not present
resource "aws_lb_listener_rule" "alb_block_missing_header" {
  listener_arn = aws_lb_listener.app_https_listener.arn
  priority     = 200

# this part returns a 403 forbidden response if the header is missing or incorrect
  action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Forbidden: Missing or incorrect secret header."
      status_code  = "403"
    }
  }

# this part does not need a specific value, it just matches if the header is missing or incorrect
  condition {
    http_header {
      http_header_name = "X-Secret-Header"
      values           = ["*"]
    }
  }
}
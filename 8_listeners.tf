
# Listeners for Application Load Balancer for Chewbacca application
# 1c_bonus_b/8_listeners.tf
# Create HTTP listener on port 80 that redirects to HTTPS
# we need to create listeners for our ALB to handle incoming traffic

resource "aws_lb_listener" "chewbacca_http_listener" {
  load_balancer_arn = aws_lb.chewbacca_alb.arn
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

resource "aws_lb_listener" "chewbacca_https_listener" {
  load_balancer_arn = aws_lb.chewbacca_alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate_validation.chewbacca_cert_validation_complete.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.chewbacca_tg.arn
  }
}
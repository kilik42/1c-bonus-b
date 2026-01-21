# CloudWatch alarm (ALB 5xx)

resource "aws_cloudwatch_metric_alarm" "chewbacca_alb_5xx_alarm" {
  alarm_name          = "chewbacca-alb-5xx"
  alarm_description   = "Alarm when ALB 5xx errors spike"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "HTTPCode_ELB_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Sum"
  threshold           = 5

  dimensions = {
    LoadBalancer = aws_lb.chewbacca_alb.arn_suffix
  }

  alarm_actions = [aws_sns_topic.chewbacca_sns_topic01.arn]
}


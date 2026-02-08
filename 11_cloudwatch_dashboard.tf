
# Create CloudWatch Dashboard for ALB metrics
# 1c_bonus_b/11_cloudwatch_dashboard.tf
# This dashboard will help monitor the health and performance of the Chewbacca ALB
# It includes widgets for 5xx errors and request count


resource "aws_cloudwatch_dashboard" "app_dashboard" {
  dashboard_name = "tetsuzai-alb-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6
        properties = {
          title  = "ALB 5xx Errors"
          region = var.aws_region
          metrics = [
            ["AWS/ApplicationELB", "HTTPCode_ELB_5XX_Count", "LoadBalancer", aws_lb.app_alb.arn_suffix]
          ]
          period = 60
          stat   = "Sum"
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 12
        height = 6
        properties = {
          title  = "ALB Request Count"
          region = var.aws_region
          metrics = [
            ["AWS/ApplicationELB", "RequestCount", "LoadBalancer", aws_lb.app_alb.arn_suffix]
          ]
          period = 60
          stat   = "Sum"
        }
      }
    ]
  })
}

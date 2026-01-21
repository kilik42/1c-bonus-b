#SNS topic for ALB alerts
# 1c_bonus_b/sns_topics.tf
# Create an SNS topic for Chewbacca ALB alerts
# we need sns topic to send alerts to
# we will create sns topic named chewbacca-alb-alerts
resource "aws_sns_topic" "chewbacca_sns_topic01" {
  name = "chewbacca-alb-alerts"
}
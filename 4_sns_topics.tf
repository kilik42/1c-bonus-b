#SNS topic for ALB alerts
# 1c_bonus_b/sns_topics.tf
# Create an SNS topic for Chewbacca ALB alerts
# we need sns topic to send alerts to
# we will create sns topic named chewbacca-alb-alerts
resource "aws_sns_topic" "alb_alerts" {
  name = "tetsuzai-alb-alerts"
}
# Create an SNS topic subscription to email for ALB alerts
# we will subscribe an email endpoint to the sns topic
resource "aws_sns_topic_subscription" "alb_alerts_email" {
  topic_arn = aws_sns_topic.alb_alerts.arn
  protocol  = "email"
  endpoint  = "marvinevins69@example.com"
}
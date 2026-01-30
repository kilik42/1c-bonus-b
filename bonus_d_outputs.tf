# Explanation: The apex URL is the front gate—humans type this when they forget subdomains.
output "tetsuzai_apex_url_https" {
  value = "https://${var.domain_name}"
}

# Explanation: Log bucket name is where the footprints live—useful when hunting 5xx or WAF blocks.
output "tetsuzai_alb_logs_bucket_name" {
  value = var.enable_alb_access_logs ? aws_s3_bucket.alb_logs[0].bucket : null
}

# output "ec2_public_ip" {
#   value = aws_instance.app_instance.public_ip
# }
output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}


# aws elbv2 describe-target-groups \
#   --names tetsuzai-tg01 \
#   --query "TargetGroups[0].TargetGroupArn" \
#   --output text

 aws elbv2 describe-target-health \
  --target-group-arn arn:aws:elasticloadbalancing:us-west-2:129762072419:targetgroup/tetsuzai-tg01/5acfc0cd4ea255bf

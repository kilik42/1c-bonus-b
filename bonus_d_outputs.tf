# Explanation: The apex URL is the front gate—humans type this when they forget subdomains.
output "tetsuzai_apex_url_https" {
  value = "https://${var.domain_name}"
}

# Explanation: Log bucket name is where the footprints live—useful when hunting 5xx or WAF blocks.
output "tetsuzai_alb_logs_bucket_name" {
  value = var.enable_alb_access_logs ? aws_s3_bucket.alb_logs[0].bucket : null
}

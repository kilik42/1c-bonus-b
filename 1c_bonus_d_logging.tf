# what all of this does: create an S3 bucket to store ALB access logs, and set the appropriate bucket policy so that the ALB can write logs to it

data "aws_caller_identity" "current" {}

# S3 bucket for ALB access logs
resource "aws_s3_bucket" "alb_logs" {
  count  = var.enable_alb_access_logs ? 1 : 0
  bucket = "tetsuzai-alb-logs-${data.aws_caller_identity.current.account_id}"
  force_destroy = true

  tags = {
    Name = "tetsuzai-alb-logs"
  }
}


# Bucket policy to allow ALB to write access logs

# resource "aws_s3_bucket_policy" "logging" {
#   bucket = aws_s3_bucket.logging.bucket
#   policy = data.aws_iam_policy_document.logging_bucket_policy.json
# }


resource "aws_s3_bucket_policy" "alb_logs_policy" {
  count  = var.enable_alb_access_logs ? 1 : 0
  bucket = aws_s3_bucket.alb_logs[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AWSALBAccessLogs"
        Effect    = "Allow"
        Principal = { Service = "logdelivery.elasticloadbalancing.amazonaws.com" }
        Action    = "s3:PutObject"
        Resource  = "${aws_s3_bucket.alb_logs[0].arn}/*"
      }
    ]
  })
}

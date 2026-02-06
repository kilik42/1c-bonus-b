
# Tetsuzai WAF Logging (CloudWatch / S3 / Firehose)
# Students choose ONE via var.tetsuzai_waf_log_destination

# ---------------------------------------------------------
# CloudWatch Logs option
# ---------------------------------------------------------
resource "aws_cloudwatch_log_group" "tetsuzai_waf_log_group" {
  count             = var.tetsuzai_waf_log_destination == "cloudwatch" ? 1 : 0
  name              = "aws-waf-logs-tetsuzai-webacl01"
  retention_in_days = var.tetsuzai_waf_log_retention_days
}

# ---------------------------------------------------------
# S3 option
# ---------------------------------------------------------
resource "aws_s3_bucket" "tetsuzai_waf_logs_bucket" {
  count  = var.tetsuzai_waf_log_destination == "s3" ? 1 : 0
  bucket = "tetsuzai-waf-logs-bucket-${data.aws_caller_identity.current.account_id}"

  tags = {
    Name = "tetsuzai-waf-logs-bucket"
  }
}

resource "aws_s3_bucket_public_access_block" "tetsuzai_waf_logs_bucket_block" {
  count                   = var.tetsuzai_waf_log_destination == "s3" ? 1 : 0
  bucket                  = aws_s3_bucket.tetsuzai_waf_logs_bucket[0].id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# ---------------------------------------------------------
# Firehose option (Firehose → S3)
# ---------------------------------------------------------
resource "aws_s3_bucket" "tetsuzai_waf_firehose_dest" {
  count  = var.tetsuzai_waf_log_destination == "firehose" ? 1 : 0
  bucket = "tetsuzai-waf-firehose-dest-${data.aws_caller_identity.current.account_id}"

  tags = {
    Name = "tetsuzai-waf-firehose-dest"
  }
}

resource "aws_kinesis_firehose_delivery_stream" "tetsuzai_waf_firehose" {
  count       = var.tetsuzai_waf_log_destination == "firehose" ? 1 : 0
  name        = "tetsuzai-waf-firehose01"
  destination = "extended_s3"

  extended_s3_configuration {
    bucket_arn         = aws_s3_bucket.tetsuzai_waf_firehose_dest[0].arn
    role_arn           = aws_iam_role.tetsuzai_firehose_role[0].arn
    buffering_interval = 60
    compression_format = "GZIP"
  }
}


# IAM role for Firehose
resource "aws_iam_role" "tetsuzai_firehose_role" {
  count = var.tetsuzai_waf_log_destination == "firehose" ? 1 : 0

  name = "tetsuzai-waf-firehose-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "firehose.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "tetsuzai_firehose_policy" {
  count = var.tetsuzai_waf_log_destination == "firehose" ? 1 : 0

  name = "tetsuzai-waf-firehose-policy"
  role = aws_iam_role.tetsuzai_firehose_role[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:PutObject", "s3:PutObjectAcl"]
        Resource = "${aws_s3_bucket.tetsuzai_waf_firehose_dest[0].arn}/*"
      }
    ]
  })
}

# ---------------------------------------------------------
# WAF Logging Configuration (ONE destination only)
# ---------------------------------------------------------
# resource "aws_wafv2_web_acl_logging_configuration" "tetsuzai_waf_logging" {
#   resource_arn = var.tetsuzai_waf_arn


#   log_destination_configs = [
#     var.tetsuzai_waf_log_destination == "cloudwatch" ? aws_cloudwatch_log_group.tetsuzai_waf_log_group[0].arn :
#     var.tetsuzai_waf_log_destination == "s3"         ? aws_s3_bucket.tetsuzai_waf_logs_bucket[0].arn :
#     var.tetsuzai_waf_log_destination == "firehose"   ? aws_kinesis_firehose_delivery_stream.tetsuzai_waf_firehose[0].arn :
#     null
#   ]

#   dynamic "redacted_fields" {
#   for_each = var.enable_waf_sampled_requests_only ? [1] : []
#   content {
#     single_header {
#       name = "cookie"
#     }
#   }
# }
# }

# data "aws_caller_identity" "current" {}

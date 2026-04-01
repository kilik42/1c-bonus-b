output "tetsuzai_waf_log_destination" {
  value = var.tetsuzai_waf_log_destination
}

output "tetsuzai_waf_cw_log_group_name" {
  value = (
    var.tetsuzai_waf_log_destination == "cloudwatch"
    ? aws_cloudwatch_log_group.tetsuzai_waf_log_group[0].name
    : null
  )
}

output "tetsuzai_waf_logs_s3_bucket" {
  value = (
    var.tetsuzai_waf_log_destination == "s3"
    ? aws_s3_bucket.tetsuzai_waf_logs_bucket[0].bucket
    : null
  )
}

output "tetsuzai_waf_firehose_name" {
  value = (
    var.tetsuzai_waf_log_destination == "firehose"
    ? aws_kinesis_firehose_delivery_stream.tetsuzai_waf_firehose[0].name
    : null
  )
}


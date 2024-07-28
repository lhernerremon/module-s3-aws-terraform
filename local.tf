locals {
  project = trimspace("${var.project_name}-${var.project_environment}")

  current_timestamp = timestamp()
  today             = formatdate("YYYYMMDD-hhmmss", local.current_timestamp)

  s3_origin_id = aws_s3_bucket.bucket_api_resources.bucket_regional_domain_name
}

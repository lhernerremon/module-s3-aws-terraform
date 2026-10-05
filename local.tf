locals {
  project     = trimspace("${var.project_name}-${var.project_environment}")
  bucket_name = coalesce(var.bucket_name, lower("${local.project}-s3"))

  s3_origin_id = aws_s3_bucket.bucket_api_resources.bucket_regional_domain_name
}

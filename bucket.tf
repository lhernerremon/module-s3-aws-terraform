resource "aws_s3_bucket" "bucket_api_resources" {
  bucket = lower("bucket-${var.project_name}-${var.project_environment}")
  tags = {
    project     = var.project_name
    environment = var.project_environment
  }
}

resource "aws_s3_bucket_cors_configuration" "bucket_api_cors" {
  bucket = aws_s3_bucket.bucket_api_resources.id

  cors_rule {
    allowed_headers = var.cors_allowed_headers
    allowed_methods = var.cors_allowed_methods
    expose_headers  = var.cors_expose_headers
    allowed_origins = var.cors_allowed_origins
    max_age_seconds = var.cors_max_age_seconds
  }
}

resource "aws_s3_bucket_public_access_block" "allow_public_access_bucket_policy" {
  bucket = aws_s3_bucket.bucket_api_resources.id

  block_public_acls       = var.policy_block_public_acls
  ignore_public_acls      = var.policy_ignore_public_acls
  block_public_policy     = var.policy_block_public_policy
  restrict_public_buckets = var.policy_restrict_public_buckets
}

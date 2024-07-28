resource "local_file" "api_user_secret_key" {
  filename = "api_key/${local.project}_secret_key.txt"
  content  = aws_iam_access_key.api_user_access_key.secret
}

resource "local_file" "api_user_access_key" {
  filename = "api_key/${local.project}_access_key.txt"
  content  = aws_iam_access_key.api_user_access_key.id
}

resource "local_file" "aws_s3_bucket_name" {
  filename = "api_key/bucket_name.txt"
  content  = aws_s3_bucket.bucket_api_resources.id
}

resource "local_file" "cloudfront_domain_name" {
  filename = "api_key/cloudfront_domain.txt"
  content  = aws_cloudfront_distribution.s3_distribution.domain_name
}

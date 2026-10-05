output "bucket_name" {
  value = aws_s3_bucket.bucket_api_resources.id
}

output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}

data "aws_iam_policy_document" "api_resources_bucket_full_access" {
  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation"
    ]
    resources = [
      aws_s3_bucket.bucket_api_resources.arn
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:GetObjectAcl",
      "s3:PutObjectAcl"
    ]
    resources = [
      "${aws_s3_bucket.bucket_api_resources.arn}/*"
    ]
  }
}

data "aws_cloudfront_cache_policy" "data_cloudfront_cache_policy" {
  name = "Managed-CachingOptimized"
}

data "aws_cloudfront_origin_request_policy" "data_cloudfront_origin_request_policy" {
  name = "Managed-CORS-S3Origin"
}

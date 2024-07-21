data "aws_iam_policy_document" "api_resources_bucket_full_access" {
  statement {
    effect = "Allow"
    actions = [
      "s3:ListAllMyBuckets"
    ]
    resources = [
      "*"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:*"
    ]
    resources = [
      "*",
    ]
  }
}

data "aws_cloudfront_cache_policy" "data_cloudfront_cache_policy" {
  name = "Managed-CachingOptimized"
}

data "aws_cloudfront_response_headers_policy" "data_cloudfront_response_headers_policy" {
  name = "Managed-CORS-With-Preflight"
}

data "aws_cloudfront_origin_request_policy" "data_cloudfront_origin_request_policy" {
  name = "Managed-CORS-S3Origin"
}

data "aws_iam_policy_document" "policy_bucket_cloudfront" {
  statement {
    sid = "AllowCloudFrontServicePrincipal"
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.bucket_api_resources.arn}/*"]
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.s3_distribution.arn]
    }
  }

  statement {
    sid = "AllowIAMUser"
    principals {
      type        = "AWS"
      identifiers = ["${aws_iam_user.api_user.arn}"]
    }
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]
    resources = [
      "${aws_s3_bucket.bucket_api_resources.arn}/*"
    ]
  }
}

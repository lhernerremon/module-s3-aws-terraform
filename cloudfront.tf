resource "aws_cloudfront_response_headers_policy" "response_headers_policy_cors" {
  name    = "${local.project}-S3-CORS"
  comment = "CORS for the S3 ${local.project}"

  cors_config {
    access_control_allow_credentials = false
    access_control_max_age_sec       = var.cors_max_age_seconds
    origin_override                  = true

    access_control_allow_headers {
      items = var.cors_allowed_headers
    }
    access_control_allow_methods {
      items = ["GET", "HEAD", "OPTIONS"]
    }
    access_control_allow_origins {
      items = var.cors_allowed_origins
    }
  }
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  enabled         = true
  http_version    = "http2and3"
  is_ipv6_enabled = var.is_ipv6_enabled
  price_class     = var.price_class
  comment         = "CDN through Cloudfront for the S3 ${local.project}"

  origin {
    domain_name = local.s3_origin_id
    origin_id   = local.s3_origin_id
  }

  restrictions {
    geo_restriction { restriction_type = "none" }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    target_origin_id       = local.s3_origin_id
    viewer_protocol_policy = var.viewer_protocol_policy

    cache_policy_id            = data.aws_cloudfront_cache_policy.data_cloudfront_cache_policy.id
    response_headers_policy_id = aws_cloudfront_response_headers_policy.response_headers_policy_cors.id
    origin_request_policy_id   = data.aws_cloudfront_origin_request_policy.data_cloudfront_origin_request_policy.id
    smooth_streaming           = false
    compress                   = var.compress
  }

  tags = {
    Name        = "${local.project}-S3-CDN"
    project     = var.project_name
    environment = var.project_environment
  }
}

resource "aws_cloudfront_origin_access_control" "cloudfront_origin_access" {
  name                              = "${local.project}-${local.today}"
  description                       = "Access control for the S3 ${local.project}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  enabled         = true
  is_ipv6_enabled = var.is_ipv6_enabled
  price_class     = var.price_class
  comment         = "CDN through Cloudfront for the S3 ${local.project}"

  origin {
    domain_name              = local.s3_origin_id
    origin_id                = local.s3_origin_id
    origin_access_control_id = aws_cloudfront_origin_access_control.cloudfront_origin_access.id
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
    response_headers_policy_id = data.aws_cloudfront_response_headers_policy.data_cloudfront_response_headers_policy.id
    origin_request_policy_id   = data.aws_cloudfront_origin_request_policy.data_cloudfront_origin_request_policy.id
    smooth_streaming           = false
    compress                   = var.compress
  }

  tags = {
    project     = var.project_name
    environment = var.project_environment
  }
}




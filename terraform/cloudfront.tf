# Website delivery AWS CloudFront Terraform configuration

data "aws_cloudfront_cache_policy" "caching_optimised" {
  name = "Managed-CachingOptimized"
}

resource "aws_cloudfront_distribution" "delivery" {
  aliases             = concat([var.domain_name], var.additional_domain_names)
  comment             = "Epic Wink website"
  default_root_object = "index.html"
  enabled             = true
  is_ipv6_enabled     = true
  http_version        = "http2and3"
  wait_for_deployment = false

  custom_error_response {
    error_caching_min_ttl = 10
    error_code            = 404
    response_code         = 404
    response_page_path    = "/errors/not-found.html"
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    cache_policy_id        = data.aws_cloudfront_cache_policy.caching_optimised.id
    compress               = true
    target_origin_id       = "epicwink-website-s3"
    viewer_protocol_policy = "redirect-to-https"
  }

  origin {
    domain_name              = aws_s3_bucket.content.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.delivery.id
    origin_id                = "epicwink-website-s3"
    origin_path              = "/content"
  }

  restrictions {
    geo_restriction {
      locations        = []
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.ssl.arn
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method       = "sni-only"
  }
}

resource "aws_cloudfront_origin_access_control" "delivery" {
  name                              = "s3-expose"
  description                       = "Access S3 via service role, managed by Terraform"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

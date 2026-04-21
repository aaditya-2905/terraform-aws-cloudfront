module "cdn" {
  source = "aaditya-2905/cloudfront/aws"

  # Domain
  aliases = ["app.example.com"]

  # Origin
  origin = {
    s3 = {
      domain_name = "my-bucket.s3.amazonaws.com"
      origin_id   = "s3-origin"
      oac_key     = "s3_oac"
    }
  }

  # OAC (Origin Access Control)
  origin_access_control = {
    s3_oac = {
      origin_type      = "s3"
      signing_behavior = "always"
      signing_protocol = "sigv4"
    }
  }

  # Cache behavior
  default_cache_behavior = {
    target_origin_id       = "s3-origin"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true
  }

  # SSL
  viewer_certificate = {
    cloudfront_default_certificate = true
  }

  # Optional (advanced – can skip)
  restrictions = {
    geo_restriction = {
      restriction_type = "none"
    }
  }

  custom_error_response = [
    {
      error_code         = 404
      response_code      = 200
      response_page_path = "/index.html"
    }
  ]

  tags = {
    Environment = "dev"
    Project     = "cloudfront-wrapper"
  }
}

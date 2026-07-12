provider "aws" {
  region = "us-west-2"  # Change this to your desired AWS region
  version = ">= 5.26.0, < 5.27.0"  # Use the specific version or version constraints you need
}

# Create an S3 bucket for hosting the static files
resource "aws_s3_bucket" "website" {
  bucket = "your-unique-s3-bucket-name"
  acl    = "public-read"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}

# Create an ACM certificate for HTTPS (optional but recommended)
resource "aws_acm_certificate" "website_cert" {
  domain_name       = "yourdomain.com"  # Change this to your domain
  validation_method = "DNS"

  tags = {
    Name = "WebsiteCertificate"
  }
}

# Create a CloudFront distribution
resource "aws_cloudfront_distribution" "website_distribution" {
  origin {
    domain_name = aws_s3_bucket.website.bucket_regional_domain_name
    origin_id   = "S3-Website"
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  # Use the ACM certificate if you're using HTTPS
  default_cache_behavior {
    target_origin_id = "S3-Website"

    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    forwarded_values {
      query_string = false
      cookies      = { forward = "none" }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # Use ACM certificate for HTTPS
  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.website_cert.arn
    ssl_support_method = "sni-only"
  }

  # Optional: Set up logging
  logging_config {
    include_cookies         = false
    bucket                 = "your-logs-s3-bucket"
    prefix                 = "cloudfront-logs/"
    bucket_owner_access    = "BucketOwnerFullControl"
  }
}

# Output the CloudFront distribution domain name
output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.website_distribution.domain_name
}

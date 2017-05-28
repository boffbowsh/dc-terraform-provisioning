variable "alias" {
  type = "list"
}

variable "origin_domain_name" {
  type = "string"
}

variable "origin_path" {
  type = "string"
  default = ""
}

variable "acm_certificate_arn" {
  type    = "string"
  default = ""
}

variable "origin_protocol_policy" {
  type = "string"
  default = "https-only"
}

resource "aws_cloudfront_distribution" "distribution" {
  enabled = true
  aliases = "${var.alias}"

  default_cache_behavior {
    allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods  = ["GET", "HEAD"]

    compress    = true
    default_ttl = 0

    forwarded_values {
      cookies {
        forward = "all"
      }

      headers = [
        "Accept",
        "Accept-Language",
        "Cache-Control",
        "Referer",
        "Upgrade-Insecure-Requests",
        "x-csrfmiddlewaretoken",
      ]

      query_string = true
    }

    max_ttl                = 900
    min_ttl                = 0
    target_origin_id       = "electionleaflets-${var.origin_domain_name}${var.origin_path}"
    viewer_protocol_policy = "redirect-to-https"
  }

  origin {
    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_keepalive_timeout = 5
      origin_protocol_policy   = "${var.origin_protocol_policy}"
      origin_read_timeout      = 30
      origin_ssl_protocols     = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }

    domain_name = "${var.origin_domain_name}"
    origin_id   = "electionleaflets-${var.origin_domain_name}${var.origin_path}"
    origin_path = "${var.origin_path}"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn            = "${var.acm_certificate_arn == "" ? "" : var.acm_certificate_arn}"
    cloudfront_default_certificate = "${var.acm_certificate_arn == "" ? true : false}"
    minimum_protocol_version       = "TLSv1"
    ssl_support_method             = "sni-only"
  }

  is_ipv6_enabled = true
  price_class     = "PriceClass_100"
}

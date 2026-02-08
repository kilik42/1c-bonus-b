#Create CloudFront ACM cert (us‑east‑1)

resource "aws_acm_certificate" "cloudfront_cert" {
  provider = aws.east

  domain_name       = "${var.app_subdomain}.${var.domain_name}"
  validation_method = "DNS"

  tags = {
    Name = "tetsuzai-cloudfront-cert"
  }
}

#what this does is create an ACM certificate in the us‑east‑1 region specifically for CloudFront, because CloudFront requires certificates to be in that region
# the certificate is for the domain www.tetsuzai.com and will be validated using DNS validation, which means we will need to create DNS records in Route 53 to prove ownership of the domain before the certificate can be issued
# data "aws_prefix_list" "cloudfront" {
#   provider = aws.east
#   name     = "com.amazonaws.global.cloudfront.origin-facing"
# }

# resource "aws_security_group_rule" "allow_cloudfront_to_alb" {
#   type              = "ingress"
#   from_port         = var.app_port
#   to_port           = var.app_port
#   protocol          = "tcp"
#   security_group_id = aws_security_group.alb_sg.id

#   cidr_blocks = ["0.0.0.0/0"]
# }

# Add CloudFront prefix list SG rule to ALB security group
# resource "aws_security_group_rule" "allow_cloudfront_to_alb" {
#   type                     = "ingress"
#   from_port                = var.app_port
#   to_port                  = var.app_port
#   protocol                 = "tcp"
#   # security_group_id = aws_security_group.alb_sg.id

#   # source_security_group_id = aws_security_group.cloudfront_sg.id 
#   prefix_list_ids   = [data.aws_prefix_list.cloudfront.id]
#   # the source_security_group_id references the CloudFront SG which allows traffic from CloudFront IP ranges
#   # this ensures that only traffic from CloudFront can reach the ALB on the application port
#   # the reference source security group will be created in the next step and will have rules to allow traffic from CloudFront IP ranges
# }

# resource "aws_security_group" "cloudfront_sg" {
#   name        = "cloudfront-allowed"
#   description = "Allows CloudFront IP ranges to reach ALB"
#   vpc_id      = data.aws_vpc.tetsuzai.id
# }

#Create CloudFront‑scoped WAF
# what this does is create a WAF web ACL that is scoped to CloudFront distributions
# this is important because CloudFront is a global service and WAF needs to be associated with it in a specific way
resource "aws_wafv2_web_acl" "cloudfront_waf" {
  name        = "tetsuzai-cloudfront-waf"
  description = "WAF for CloudFront distribution"
  provider    = aws.east
  scope       = "CLOUDFRONT"

  default_action {
    allow {}
  }
  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "tetsuzai-cloudfront-waf"
    sampled_requests_enabled   = true
  }

  tags = {
    Name = "tetsuzai-cloudfront-waf"
  }
}


# Create CloudFront distribution pointing to ALB
resource "aws_cloudfront_distribution" "tetsuzai_cf" {
  origin {
    domain_name = aws_lb.app_alb.dns_name
    origin_id   = "tetsuzai-alb-origin"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]


    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CloudFront distribution for Tetsuzai app"
  default_root_object = "index.html"

  aliases = ["${var.app_subdomain}.${var.domain_name}"]


  # for lab 1cbonusE, we will use the default cache policy and origin request policy, which means CloudFront will cache based on URL path only and won't forward any cookies, headers, or query strings to the origin. This is a simple setup that works for static content but may not be suitable for dynamic API responses. In lab 2b, we will create custom cache policies and origin request policies to achieve better cache correctness for our application.
  # default_cache_behavior {
  #   allowed_methods  = ["GET", "HEAD", "OPTIONS"]
  #   cached_methods   = ["GET", "HEAD"]
  #   target_origin_id = "tetsuzai-alb-origin"

  #   forwarded_values {
  #     query_string = false
  #     cookies {
  #       forward = "none"
  #     }
  #   }

  #   viewer_protocol_policy = "redirect-to-https"
  #   min_ttl                = 0
  #   default_ttl            = 3600
  #   max_ttl                = 86400
  # }

  # FOR LAB 2B, we will use the custom cache policy and origin request policy that we defined in lab2b_cache_correctness.tf. The cache policy disables caching for API responses by setting all TTLs to 0, and the origin request policy forwards all relevant information (cookies, headers, query strings) to the origin so that the API can function correctly even if responses aren't cached. This setup allows us to have better cache correctness for our application while still leveraging CloudFront's caching capabilities for static content.
  default_cache_behavior {
    target_origin_id       = "tetsuzai-alb-origin"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods  = ["GET", "HEAD"]

    cache_policy_id          = aws_cloudfront_cache_policy.tetsuzai_cache_api_disabled.id
    origin_request_policy_id = aws_cloudfront_origin_request_policy.tetsuzai_orp_api.id

    compress = true
  }


  ordered_cache_behavior {
    path_pattern           = "/static/*"
    target_origin_id       = "tetsuzai-alb-origin"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    cache_policy_id            = aws_cloudfront_cache_policy.tetsuzai_cache_static.id
    origin_request_policy_id   = aws_cloudfront_origin_request_policy.tetsuzai_orp_static.id
    response_headers_policy_id = aws_cloudfront_response_headers_policy.tetsuzai_rhp_static_cachecontrol.id

    compress = true
  }

  ordered_cache_behavior {
    path_pattern           = "/api/*"
    target_origin_id       = "tetsuzai-alb-origin"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods  = ["GET", "HEAD"]

    cache_policy_id          = aws_cloudfront_cache_policy.tetsuzai_cache_api_disabled.id
    origin_request_policy_id = aws_cloudfront_origin_request_policy.tetsuzai_orp_api.id

    compress = true
  }


  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.cloudfront_cert.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  web_acl_id = aws_wafv2_web_acl.cloudfront_waf.arn

  depends_on = [
    aws_acm_certificate_validation.app_cert_validation
  ]
}
# resource "aws_lb_target_group_attachment" "app" {
#  target_group_arn = aws_lb_target_group.TG0_ASG01.arn

#   target_id        = aws_instance.tetsuzai_app.id
#   port             = 80
# }


# Lab 2B: Cache Correctness Overlay


# 1) Cache policy: STATIC (aggressive)
# - Cache everything (ignore cookies, headers, query strings)
# - Long TTLs (cache for a long time)
resource "aws_cloudfront_cache_policy" "tetsuzai_cache_static" {
  name        = "tetsuzai-cache-static"
  default_ttl = 86400    # 1 day
  max_ttl     = 31536000 # 1 year
  min_ttl     = 0

  # Cache key: include Accept-Encoding for gzip/brotli support, but ignore cookies, headers, query strings (static content doesn't need them)
  parameters_in_cache_key_and_forwarded_to_origin {
    enable_accept_encoding_gzip   = true
    enable_accept_encoding_brotli = true

    cookies_config {
      cookie_behavior = "none"
    }

    headers_config {
      header_behavior = "none" # don't vary on headers
    }

    query_strings_config {
      query_string_behavior = "none" # ignore query strings for static
    }
  }
}

# 2) Cache policy: API (safe default = disable caching)
# - Don't cache API responses (0 TTLs)
# - Forward all relevant info to origin (cookies, headers, query strings) so API can function correctly, even if responses aren't cached
resource "aws_cloudfront_cache_policy" "tetsuzai_cache_api_disabled" {
  name        = "tetsuzai-cache-api-disabled"
  default_ttl = 0
  max_ttl     = 0
  min_ttl     = 0

  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config {
      cookie_behavior = "none"
    }

    headers_config {
      header_behavior = "none"
    }

    query_strings_config {
      query_string_behavior = "none"
    }
  }
}



# 3) Origin request policy: STATIC minimal forwarding
resource "aws_cloudfront_origin_request_policy" "tetsuzai_orp_static" {
  name = "tetsuzai-orp-static"

  cookies_config {
    cookie_behavior = "none"
  }

  headers_config {
    header_behavior = "none"
  }

  query_strings_config {
    query_string_behavior = "none"
  }
}

# 4) Origin request policy: API forwarding (forward what origin needs)
resource "aws_cloudfront_origin_request_policy" "tetsuzai_orp_api" {
  name = "tetsuzai-orp-api"

  cookies_config {
    cookie_behavior = "none"
  }

  headers_config {
    header_behavior = "whitelist"
    headers {
      items = ["Origin"]
    }
  }

  query_strings_config {
    query_string_behavior = "all"
  }
}


# 5) Response headers policy: force Cache-Control on static
resource "aws_cloudfront_response_headers_policy" "tetsuzai_rhp_static_cachecontrol" {
  name = "tetsuzai-rhp-static-cachecontrol"

  custom_headers_config {
    items {
      header   = "Cache-Control"
      override = true
      value    = "public, max-age=31536000, immutable"
    }
  }
}

resource "aws_lb" "application_lb" {
  name               = "application-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.loadbalancer_sg.id]
  subnets            = [data.aws_subnet.public-a.id, data.aws_subnet.public-b.id]

  tags = {
    Name = "application-lb"
  }
}

resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.application_lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate_validation.cert_validation.certificate_arn

  default_action {
    type = "forward"
    forward {
      target_group {
        arn = aws_lb_target_group.blue_target.arn
      }
    }
  }
}

resource "aws_acm_certificate" "cert" {
  domain_name       = "wp.reggiestestdomain.com"
  validation_method = "DNS"
}

data "aws_route53_zone" "selected" {
  name = "reggiestestdomain.com."
}

locals {
  cert_validation = tolist(aws_acm_certificate.cert.domain_validation_options)
}

resource "aws_route53_record" "cert_validation" {
  name    = local.cert_validation[0].resource_record_name
  type    = local.cert_validation[0].resource_record_type
  zone_id = data.aws_route53_zone.selected.zone_id
  records = [local.cert_validation[0].resource_record_value]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "cert_validation" {
  provider                = aws.us_east_1
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [aws_route53_record.cert_validation.fqdn]
}

# CloudFront Distribution
resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_lb.application_lb.dns_name
    origin_id   = aws_lb.application_lb.id

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CloudFront distribution for application load balancer"

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_lb.application_lb.id

    forwarded_values {
      query_string = true
      headers      = ["*"]

      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  aliases = ["wp.reggiestestdomain.com"]

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.cert.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.1_2016"
  }
}


resource "aws_route53_record" "www" {
  name    = "wp.reggiestestdomain.com"
  type    = "A"
  zone_id = data.aws_route53_zone.selected.zone_id

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

#SQL Injection Rule
resource "aws_wafregional_sql_injection_match_set" "sql_injection_match_set" {
  name = "tfWafSqlInjectionMatchSet"
  
  sql_injection_match_tuple {
    field_to_match {
      type = "URI"
    }

    text_transformation = "URL_DECODE"
  }
}

resource "aws_wafregional_rule" "sql_injection_rule" {
  depends_on  = [aws_wafregional_sql_injection_match_set.sql_injection_match_set]
  name        = "tfWAFRule"
  metric_name = "tfWAFRule"
  
  predicate {
    data_id = aws_wafregional_sql_injection_match_set.sql_injection_match_set.id
    negated = false
    type    = "SqlInjectionMatch"
  }
}

#ACL
resource "aws_wafregional_web_acl" "waf_acl" {
  depends_on  = [aws_wafregional_rule.sql_injection_rule]
  name        = "tfWebACL"
  metric_name = "tfWebACL"

  default_action {
    type = "ALLOW"
  }

  rule {
    action {
      type = "BLOCK"
    }

    priority = 1
    rule_id  = aws_wafregional_rule.sql_injection_rule.id
    type     = "REGULAR"
  }
}

# Associate WAF ACL with Application Load Balancer
resource "aws_wafregional_web_acl_association" "waf_acl_association" {
  depends_on    = [aws_wafregional_web_acl.waf_acl]
  resource_arn  = aws_lb.application_lb.arn
  web_acl_id    = aws_wafregional_web_acl.waf_acl.id
}

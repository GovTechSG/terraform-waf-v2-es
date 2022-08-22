locals {
  s3_bucket_arn = "arn:aws:s3:::${var.s3_bucket_name}"
}

provider "aws" {
  alias  = "wafv2"
  region = var.aws_region
}

resource "aws_wafv2_ip_set" "ipset-rate-limit" {
  provider = aws.wafv2

  name               = "${var.name}-ipset-to-rate-limit"
  description        = var.description
  scope              = var.scope
  ip_address_version = "IPV4"
  addresses          = var.rate_limit_ips

  tags = var.tags
}

resource "aws_wafv2_ip_set" "ipset-allow" {
  provider = aws.wafv2

  name               = "${var.name}-ipset-to-allow"
  description        = var.description
  scope              = var.scope
  ip_address_version = "IPV4"
  addresses          = var.allow_ips

  tags = var.tags
}

resource "aws_wafv2_ip_set" "ipset-block" {
  provider = aws.wafv2

  name               = "${var.name}-ipset-to-block"
  description        = var.description
  scope              = var.scope
  ip_address_version = "IPV4"
  addresses          = var.block_ips

  tags = var.tags
}

resource "aws_wafv2_web_acl" "main" {
  provider = aws.wafv2

  name        = var.name
  description = var.description
  scope       = var.scope

  default_action {
    allow {}
  }

  rule {
    name     = "IPSet-Rate-Limit"
    priority = var.ipset_rate_limit.priority

    action {
      dynamic "count" {
        for_each = var.ipset_rate_limit.action == "count" ? [""] : []
        content {
        }
      }

      dynamic "block" {
        for_each = var.ipset_rate_limit.action == "block" ? [""] : []
        content {
        }
      }
    }

    statement {

      rate_based_statement {
        aggregate_key_type = "IP"
        limit              = var.ipset_rate_limit.rate

        dynamic "scope_down_statement" {
          for_each = var.ipset_rate_limit.ignore_ipset == true ? [] : [""]
          content {
            ip_set_reference_statement {
              arn = aws_wafv2_ip_set.ipset-rate-limit.arn
            }
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "IPSet-Rate-Limit"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "IPSet-Block"
    priority = var.ipset_block.priority

    action {
      dynamic "count" {
        for_each = var.ipset_block.action == "count" ? [""] : []
        content {
        }
      }

      dynamic "block" {
        for_each = var.ipset_block.action == "block" ? [""] : []
        content {
        }
      }
    }

    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.ipset-block.arn
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "IPSet-Block"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "IPSet-Allow"
    priority = 0

    action {
      allow {}
    }

    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.ipset-allow.arn
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "IPSet-Allow"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "BotsUserAgent"
    priority = var.bots_useragent_throttling.priority

    action {
      dynamic "count" {
        for_each = var.bots_useragent_throttling.action == "count" ? [""] : []
        content {
        }
      }

      dynamic "block" {
        for_each = var.bots_useragent_throttling.action == "block" ? [""] : []
        content {
        }
      }
    }

    statement {
      rate_based_statement {
        aggregate_key_type = "IP"
        limit              = 300

        scope_down_statement {
          or_statement {
            statement {

              byte_match_statement {
                positional_constraint = "CONTAINS"
                search_string         = "guzzlehttp"

                field_to_match {

                  single_header {
                    name = "user-agent"
                  }
                }

                text_transformation {
                  priority = 0
                  type     = "LOWERCASE"
                }
              }
            }
            statement {

              byte_match_statement {
                positional_constraint = "CONTAINS"
                search_string         = "trovitbot"

                field_to_match {

                  single_header {
                    name = "user-agent"
                  }
                }

                text_transformation {
                  priority = 0
                  type     = "LOWERCASE"
                }
              }
            }
            statement {

              byte_match_statement {
                positional_constraint = "CONTAINS"
                search_string         = "phantomjs"

                field_to_match {

                  single_header {
                    name = "user-agent"
                  }
                }

                text_transformation {
                  priority = 0
                  type     = "LOWERCASE"
                }
              }
            }
            statement {

              byte_match_statement {
                positional_constraint = "CONTAINS"
                search_string         = "wget"

                field_to_match {

                  single_header {
                    name = "user-agent"
                  }
                }

                text_transformation {
                  priority = 0
                  type     = "LOWERCASE"
                }
              }
            }
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "BotsUserAgent"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "GeoLocation"
    priority = var.geolocation_throttling.priority

    action {
      dynamic "count" {
        for_each = var.geolocation_throttling.action == "count" ? [""] : []
        content {
        }
      }

      dynamic "block" {
        for_each = var.geolocation_throttling.action == "block" ? [""] : []
        content {
        }
      }
    }

    statement {
      rate_based_statement {
        aggregate_key_type = "IP"
        limit              = 500

        scope_down_statement {
          or_statement {
            statement {

              geo_match_statement {
                country_codes = [
                  "CN",
                ]
              }
            }
            statement {
              geo_match_statement {
                country_codes = [
                  "IN",
                ]
              }
            }
            statement {
              geo_match_statement {
                country_codes = [
                  "PL",
                ]
              }
            }
            statement {
              geo_match_statement {
                country_codes = [
                  "RU",
                ]
              }
            }
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "GeoLocation"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesAnonymousIpList"
    priority = var.aws_anonymousip_list.priority

    override_action {
      dynamic "count" {
        for_each = var.aws_anonymousip_list.action == "count" ? [""] : []
        content {
        }
      }

      dynamic "none" {
        for_each = var.aws_anonymousip_list.action == "none" ? [""] : []
        content {
        }
      }
    }

    statement {

      managed_rule_group_statement {
        name        = "AWSManagedRulesAnonymousIpList"
        vendor_name = "AWS"

        excluded_rule {
          name = "HostingProviderIPList"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesAnonymousIpList"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesKnownBadInputsRuleSet"
    priority = var.aws_badinputs_ruleset.priority

    override_action {
      dynamic "count" {
        for_each = var.aws_badinputs_ruleset.action == "count" ? [""] : []
        content {
        }
      }

      dynamic "none" {
        for_each = var.aws_badinputs_ruleset.action == "none" ? [""] : []
        content {
        }
      }
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesKnownBadInputsRuleSet"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesLinuxRuleSet"
    priority = var.aws_linux_ruleset.priority

    override_action {
      dynamic "count" {
        for_each = var.aws_linux_ruleset.action == "count" ? [""] : []
        content {
        }
      }

      dynamic "none" {
        for_each = var.aws_linux_ruleset.action == "none" ? [""] : []
        content {
        }
      }
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesLinuxRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesLinuxRuleSet"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesSQLiRuleSet"
    priority = var.aws_sqli_ruleset.priority

    override_action {
      dynamic "count" {
        for_each = var.aws_sqli_ruleset.action == "count" ? [""] : []
        content {
        }
      }

      dynamic "none" {
        for_each = var.aws_sqli_ruleset.action == "none" ? [""] : []
        content {
        }
      }
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesSQLiRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesSQLiRuleSet"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesCommonRuleSet"
    priority = var.aws_common_ruleset.priority

    override_action {
      dynamic "count" {
        for_each = var.aws_common_ruleset.action == "count" ? [""] : []
        content {
        }
      }

      dynamic "none" {
        for_each = var.aws_common_ruleset.action == "none" ? [""] : []
        content {
        }
      }
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"

        excluded_rule {
          name = "GenericRFI_BODY"
        }

        excluded_rule {
          name = "SizeRestrictions_BODY"
        }

        excluded_rule {
          name = "SizeRestrictions_QUERYSTRING"
        }

        excluded_rule {
          name = "SizeRestrictions_URIPATH"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesCommonRuleSet"
      sampled_requests_enabled   = true
    }
  }

  tags = var.tags

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = var.name
    sampled_requests_enabled   = true
  }
}

resource "aws_wafv2_web_acl_association" "waf_association" {
  count        = var.association_resource_arns
  resource_arn = var.association_resource_arns[count.index]
  web_acl_arn  = aws_wafv2_web_acl.main.arn
}
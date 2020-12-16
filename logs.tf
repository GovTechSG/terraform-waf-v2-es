
# set role and policy for firehose to access s3 bucket.
data "aws_iam_policy_document" "firehose_role_assume_policy" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "Service"

      identifiers = [
        "firehose.amazonaws.com",
      ]
    }
  }
}

resource "aws_iam_role" "firehose" {
  name                 = "firehose-webacl-${lower(var.name)}-delivery-role"
  description          = "Service Role for ${lower(var.name)}-WebACL Firehose"
  assume_role_policy   = data.aws_iam_policy_document.firehose_role_assume_policy.json
  permissions_boundary = var.permissions_boundary
}

resource "aws_iam_policy" "allow_es_actions" {
  count  = var.logging_to_es ? 1 : 0
  name   = "firehose-webacl-${lower(var.name)}-policy"
  policy = data.aws_iam_policy_document.allow_es_actions.json
}

resource "aws_iam_role_policy_attachment" "firehose_on_es" {
  count      = var.logging_to_es ? 1 : 0
  role       = aws_iam_role.firehose.name
  policy_arn = aws_iam_policy.allow_es_actions[0].arn
}

data "aws_iam_policy_document" "allow_es_actions" {
  statement {
    effect = "Allow"

    actions = [
      "s3:AbortMultipartUpload",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:PutObject",
    ]

    resources = [
      local.s3_bucket_arn,
      "${local.s3_bucket_arn}/*",
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "ec2:DescribeVpcs",
      "ec2:DescribeVpcAttribute",
      "ec2:DescribeSubnets",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeNetworkInterfaces",
      "ec2:CreateNetworkInterface",
      "ec2:CreateNetworkInterfacePermission",
      "ec2:DeleteNetworkInterface"
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "es:DescribeElasticsearchDomain",
      "es:DescribeElasticsearchDomains",
      "es:DescribeElasticsearchDomainConfig",
      "es:ESHttpPost",
      "es:ESHttpPut"
    ]

    resources = [
      var.logging_to_es_domain_arn,
      "${var.logging_to_es_domain_arn}/*"
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "es:ESHttpGet"
    ]

    resources = [
      "${var.logging_to_es_domain_arn}/_all/_settings",
      "${var.logging_to_es_domain_arn}/_cluster/stats",
      "${var.logging_to_es_domain_arn}/${var.logging_to_es_index_name}*/_mapping/${var.logging_to_es_index_type}",
      "${var.logging_to_es_domain_arn}/_nodes",
      "${var.logging_to_es_domain_arn}/_nodes/stats",
      "${var.logging_to_es_domain_arn}/_nodes/*/stats",
      "${var.logging_to_es_domain_arn}/_stats",
      "${var.logging_to_es_domain_arn}/${var.logging_to_es_index_name}*/_stats"
    ]
  }
}

resource "aws_kinesis_firehose_delivery_stream" "waf" {
  count = 1

  name        = "aws-waf-logs-${lower(var.name)}-webacl-${var.hex_id}"
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn   = aws_iam_role.firehose.arn
    bucket_arn = local.s3_bucket_arn

    prefix              = "waf/${var.name}/"
    error_output_prefix = "waf/${var.name}/errors/"

    compression_format = "ZIP"
    buffer_size        = var.firehose_buffer_size
    buffer_interval    = var.firehose_buffer_interval
  }

  tags = var.tags
}

resource "aws_kinesis_firehose_delivery_stream" "waf-to-es" {
  count = var.logging_to_es ? 1 : 0

  name        = "aws-waf-logs-${lower(var.name)}-webacl-for-es"
  destination = "elasticsearch"

  s3_configuration {
    role_arn   = aws_iam_role.firehose.arn
    bucket_arn = local.s3_bucket_arn

    kms_key_arn = var.logging_to_es_s3_kms_key_arn
    prefix      = "waf/${var.name}/"

    buffer_size        = var.logging_to_es_firehose_buffer_size
    buffer_interval    = var.logging_to_es_firehose_buffer_interval
    compression_format = "GZIP"
  }

  elasticsearch_configuration {
    domain_arn = var.logging_to_es_domain_arn
    role_arn   = aws_iam_role.firehose.arn

    index_name            = var.logging_to_es_index_name
    index_rotation_period = var.logging_to_es_index_rotation

    s3_backup_mode = "AllDocuments"

    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = "/aws/kinesisfirehose/aws-waf-logs-cirithungol-regional-webacl-for-es"
      log_stream_name = "ElasticsearchDelivery"
    }

    processing_configuration {
      enabled = false
    }

    vpc_config {
      role_arn           = aws_iam_role.firehose.arn
      subnet_ids         = var.logging_to_es_subnet_ids
      security_group_ids = var.logging_to_es_sec_grp_id
    }
  }

  server_side_encryption {
    enabled  = false
    key_type = "AWS_OWNED_CMK"
  }

  tags = var.tags
}
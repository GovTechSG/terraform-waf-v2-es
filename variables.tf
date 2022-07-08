variable "name" {
  description = "Name of WAFv2"
  type        = string
  default     = ""
}

variable "description" {
  description = "Description of the WAFv2"
  type        = string
  default     = "-"
}

variable "aws_region" {
  description = "Region"
  type        = string
  default     = "ap-southeast-1"
}

variable "scope" {
  description = "Scope of WAFv2"
  type        = string
  default     = "REGIONAL"
}

variable "aws_common_ruleset" {
  description = "AWS Managed CommonRuleSet, use Count or None for action."
  type        = map(any)
}

variable "aws_sqli_ruleset" {
  description = "AWS Managed SQLiRuleSet, use Count or None for action."
  type        = map(any)
}

variable "aws_linux_ruleset" {
  description = "AWS Managed LinuxRuleSet, use Count or None for action."
  type        = map(any)
}

variable "aws_badinputs_ruleset" {
  description = "AWS Managed KnownBadInputsRuleSet, use Count or None for action."
  type        = map(any)
}

variable "aws_anonymousip_list" {
  description = "AWS Managed AnonymousIPList, use Count or None for action."
  type        = map(any)
}

variable "geolocation_throttling" {
  description = "Geolocation Throttling, use Count or Block for action."
  type        = map(any)
}

variable "bots_useragent_throttling" {
  description = "Bots Using Specific User Agents Throttling, use Count or Block for action."
  type        = map(any)
}

variable "ipset_block" {
  description = "Block the specific IPs, use Count or Block for action."
  type        = map(any)
}

variable "ipset_rate_limit" {
  description = "Rate-limit the specific IPs, use Count or Block for action. Default to Count. Set ignore_ipset to true if you want to rate limit ALL ip addresses. Rate is how many reqs per 5 min "
  type        = map(any)
  default     = {
    priority      = -1
    action        = "count"
    ignore_ipset  = false
    rate          = 300
  }
}

variable "allow_ips" {
  description = "IPs to be always allowed (the action is Allow)"
  type        = set(string)
  default     = []
}

variable "block_ips" {
  description = "IPs to be blocked"
  type        = set(string)
  default     = []
}

variable "rate_limit_ips" {
  description = "IPs to be rate-limited"
  type        = set(string)
  default     = []
}

variable "s3_bucket_name" {
  description = "S3 Bucket for Logging"
  default     = ""
}

variable "permissions_boundary" {
  description = "Boundary required for GCC"
  default     = ""
}

variable "firehose_buffer_size" {
  description = "Buffer incoming data to the specified size, in MBs, before delivering it to the destination. Valid value is between 64-128. Recommended is 128, specifying a smaller buffer size can result in the delivery of very small S3 objects, which are less efficient to query."
  default     = 128
}

variable "firehose_buffer_interval" {
  description = "Buffer incoming data for the specified period of time, in seconds, before delivering it to the destination. Valid value is between 60-900. Smaller value makes the logs delivered faster. Bigger value increase the chance to make the file size bigger, which are more efficient to query."
  default     = 300
}

variable "hex_id" {
  description = "This was legacy id used in cloudformation track"
  type        = string
}

variable "logging_to_es" {
  description = "(Optional) Logging to ES, default to false."
  type        = bool
  default     = false
}

variable "logging_to_es_domain_arn" {
  description = "The ARN of ES Domain is required is logging_to_es is true. "
  type        = string
  default     = ""
}

variable "logging_to_es_index_name" {
  description = "The index_name for ES is required if `logging_to_es` is true. "
  type        = string
  default     = ""
}

variable "logging_to_es_index_type" {
  description = "The index_type of ES is required if `logging_to_es` is true. "
  type        = string
  default     = ""
}

variable "logging_to_es_index_rotation" {
  description = "The index_rotation of ES is required if `logging_to_es` is true. "
  type        = string
  default     = "OneWeek"
}

variable "logging_to_es_s3_kms_key_arn" {
  description = "The KMS key for S3 encryption, required if `logging_to_es` is true. "
  type        = string
  default     = ""
}

variable "logging_to_es_subnet_ids" {
  description = "The subnet ids of ES is required if `logging_to_es` is true. "
  type        = set(string)
  default     = []
}

variable "logging_to_es_sec_grp_id" {
  description = "The security group of ES is required if `logging_to_es` is true. "
  type        = set(string)
  default     = []
}

variable "logging_to_es_firehose_buffer_size" {
  description = "The firehose_buffer_size is required if `logging_to_es` is true. "
  type        = number
  default     = 15
}

variable "logging_to_es_firehose_buffer_interval" {
  description = "The firehose_buffer_interval is required if `logging_to_es` is true. "
  type        = number
  default     = 300
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)

  default = {
    "Terraform" = "True"
  }
}
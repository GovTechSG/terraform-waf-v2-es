## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_aws.wafv2"></a> [aws.wafv2](#provider\_aws.wafv2) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.allow_es_actions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.firehose](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.firehose_on_es](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kinesis_firehose_delivery_stream.waf](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kinesis_firehose_delivery_stream) | resource |
| [aws_kinesis_firehose_delivery_stream.waf-to-es](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kinesis_firehose_delivery_stream) | resource |
| [aws_wafv2_ip_set.ipset-allow](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_ip_set) | resource |
| [aws_wafv2_ip_set.ipset-block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_ip_set) | resource |
| [aws_wafv2_ip_set.ipset-rate-limit](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_ip_set) | resource |
| [aws_wafv2_web_acl.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl) | resource |
| [aws_wafv2_web_acl_association.waf_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_association) | resource |
| [aws_iam_policy_document.allow_es_actions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.firehose_role_assume_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_ips"></a> [allow\_ips](#input\_allow\_ips) | IPs to be always allowed (the action is Allow) | `set(string)` | `[]` | no |
| <a name="input_association_resource_arns"></a> [association\_resource\_arns](#input\_association\_resource\_arns) | Resources you want to associate with WAF | `set(string)` | `[]` | no |
| <a name="input_aws_anonymousip_list"></a> [aws\_anonymousip\_list](#input\_aws\_anonymousip\_list) | AWS Managed AnonymousIPList, use Count or None for action. | `map(any)` | n/a | yes |
| <a name="input_aws_badinputs_ruleset"></a> [aws\_badinputs\_ruleset](#input\_aws\_badinputs\_ruleset) | AWS Managed KnownBadInputsRuleSet, use Count or None for action. | `map(any)` | n/a | yes |
| <a name="input_aws_common_ruleset"></a> [aws\_common\_ruleset](#input\_aws\_common\_ruleset) | AWS Managed CommonRuleSet, use Count or None for action. | `map(any)` | n/a | yes |
| <a name="input_aws_linux_ruleset"></a> [aws\_linux\_ruleset](#input\_aws\_linux\_ruleset) | AWS Managed LinuxRuleSet, use Count or None for action. | `map(any)` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | Region | `string` | `"ap-southeast-1"` | no |
| <a name="input_aws_sqli_ruleset"></a> [aws\_sqli\_ruleset](#input\_aws\_sqli\_ruleset) | AWS Managed SQLiRuleSet, use Count or None for action. | `map(any)` | n/a | yes |
| <a name="input_block_ips"></a> [block\_ips](#input\_block\_ips) | IPs to be blocked | `set(string)` | `[]` | no |
| <a name="input_bots_useragent_throttling"></a> [bots\_useragent\_throttling](#input\_bots\_useragent\_throttling) | Bots Using Specific User Agents Throttling, use Count or Block for action. | `map(any)` | n/a | yes |
| <a name="input_default_block"></a> [default\_block](#input\_default\_block) | make it default to block instead of allow | `bool` | `false` | no |
| <a name="input_description"></a> [description](#input\_description) | Description of the WAFv2 | `string` | `"-"` | no |
| <a name="input_firehose_buffer_interval"></a> [firehose\_buffer\_interval](#input\_firehose\_buffer\_interval) | Buffer incoming data for the specified period of time, in seconds, before delivering it to the destination. Valid value is between 60-900. Smaller value makes the logs delivered faster. Bigger value increase the chance to make the file size bigger, which are more efficient to query. | `number` | `300` | no |
| <a name="input_firehose_buffer_size"></a> [firehose\_buffer\_size](#input\_firehose\_buffer\_size) | Buffer incoming data to the specified size, in MBs, before delivering it to the destination. Valid value is between 64-128. Recommended is 128, specifying a smaller buffer size can result in the delivery of very small S3 objects, which are less efficient to query. | `number` | `128` | no |
| <a name="input_geolocation_throttling"></a> [geolocation\_throttling](#input\_geolocation\_throttling) | Geolocation Throttling, use Count or Block for action. | `map(any)` | n/a | yes |
| <a name="input_hex_id"></a> [hex\_id](#input\_hex\_id) | This was legacy id used in cloudformation track | `string` | n/a | yes |
| <a name="input_ipset_block"></a> [ipset\_block](#input\_ipset\_block) | Block the specific IPs, use Count or Block for action. | `map(any)` | n/a | yes |
| <a name="input_ipset_rate_limit"></a> [ipset\_rate\_limit](#input\_ipset\_rate\_limit) | Rate-limit the specific IPs, use Count or Block for action. Default to Count. Set ignore\_ipset to true if you want to rate limit ALL ip addresses. Rate is how many reqs per 5 min | <pre>object({<br>    priority      = number<br>    action        = string<br>    ignore_ipset  = bool<br>    rate          = number<br>  })</pre> | <pre>{<br>  "action": "count",<br>  "ignore_ipset": false,<br>  "priority": -1,<br>  "rate": 300<br>}</pre> | no |
| <a name="input_logging_to_es"></a> [logging\_to\_es](#input\_logging\_to\_es) | (Optional) Logging to ES, default to false. | `bool` | `false` | no |
| <a name="input_logging_to_es_domain_arn"></a> [logging\_to\_es\_domain\_arn](#input\_logging\_to\_es\_domain\_arn) | The ARN of ES Domain is required is logging\_to\_es is true. | `string` | `""` | no |
| <a name="input_logging_to_es_firehose_buffer_interval"></a> [logging\_to\_es\_firehose\_buffer\_interval](#input\_logging\_to\_es\_firehose\_buffer\_interval) | The firehose\_buffer\_interval is required if `logging_to_es` is true. | `number` | `300` | no |
| <a name="input_logging_to_es_firehose_buffer_size"></a> [logging\_to\_es\_firehose\_buffer\_size](#input\_logging\_to\_es\_firehose\_buffer\_size) | The firehose\_buffer\_size is required if `logging_to_es` is true. | `number` | `15` | no |
| <a name="input_logging_to_es_index_name"></a> [logging\_to\_es\_index\_name](#input\_logging\_to\_es\_index\_name) | The index\_name for ES is required if `logging_to_es` is true. | `string` | `""` | no |
| <a name="input_logging_to_es_index_rotation"></a> [logging\_to\_es\_index\_rotation](#input\_logging\_to\_es\_index\_rotation) | The index\_rotation of ES is required if `logging_to_es` is true. | `string` | `"OneWeek"` | no |
| <a name="input_logging_to_es_index_type"></a> [logging\_to\_es\_index\_type](#input\_logging\_to\_es\_index\_type) | The index\_type of ES is required if `logging_to_es` is true. | `string` | `""` | no |
| <a name="input_logging_to_es_s3_kms_key_arn"></a> [logging\_to\_es\_s3\_kms\_key\_arn](#input\_logging\_to\_es\_s3\_kms\_key\_arn) | The KMS key for S3 encryption, required if `logging_to_es` is true. | `string` | `""` | no |
| <a name="input_logging_to_es_sec_grp_id"></a> [logging\_to\_es\_sec\_grp\_id](#input\_logging\_to\_es\_sec\_grp\_id) | The security group of ES is required if `logging_to_es` is true. | `set(string)` | `[]` | no |
| <a name="input_logging_to_es_subnet_ids"></a> [logging\_to\_es\_subnet\_ids](#input\_logging\_to\_es\_subnet\_ids) | The subnet ids of ES is required if `logging_to_es` is true. | `set(string)` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of WAFv2 | `string` | `""` | no |
| <a name="input_permissions_boundary"></a> [permissions\_boundary](#input\_permissions\_boundary) | Boundary required for GCC | `string` | `""` | no |
| <a name="input_rate_limit_ips"></a> [rate\_limit\_ips](#input\_rate\_limit\_ips) | IPs to be rate-limited | `set(string)` | `[]` | no |
| <a name="input_s3_bucket_name"></a> [s3\_bucket\_name](#input\_s3\_bucket\_name) | S3 Bucket for Logging | `string` | `""` | no |
| <a name="input_scope"></a> [scope](#input\_scope) | Scope of WAFv2 | `string` | `"REGIONAL"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | <pre>{<br>  "Terraform": "True"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_wafv2_arn"></a> [wafv2\_arn](#output\_wafv2\_arn) | ARN of WAFv2 |

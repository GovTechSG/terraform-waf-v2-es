## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| aws.wafv2 | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| allow\_ips | IPs to be always allowed (the action is Allow) | `set(string)` | `[]` | no |
| aws\_anonymousip\_list | AWS Managed AnonymousIPList, use Count or None for action. | `map` | n/a | yes |
| aws\_badinputs\_ruleset | AWS Managed KnownBadInputsRuleSet, use Count or None for action. | `map` | n/a | yes |
| aws\_common\_ruleset | AWS Managed CommonRuleSet, use Count or None for action. | `map` | n/a | yes |
| aws\_linux\_ruleset | AWS Managed LinuxRuleSet, use Count or None for action. | `map` | n/a | yes |
| aws\_region | Region | `string` | `"ap-southeast-1"` | no |
| aws\_sqli\_ruleset | AWS Managed SQLiRuleSet, use Count or None for action. | `map` | n/a | yes |
| block\_ips | IPs to be blocked | `set(string)` | `[]` | no |
| bots\_useragent\_throttling | Bots Using Specific User Agents Throttling, use Count or Block for action. | `map` | n/a | yes |
| description | Description of the WAFv2 | `string` | `"-"` | no |
| firehose\_buffer\_interval | Buffer incoming data for the specified period of time, in seconds, before delivering it to the destination. Valid value is between 60-900. Smaller value makes the logs delivered faster. Bigger value increase the chance to make the file size bigger, which are more efficient to query. | `number` | `300` | no |
| firehose\_buffer\_size | Buffer incoming data to the specified size, in MBs, before delivering it to the destination. Valid value is between 64-128. Recommended is 128, specifying a smaller buffer size can result in the delivery of very small S3 objects, which are less efficient to query. | `number` | `128` | no |
| geolocation\_throttling | Geolocation Throttling, use Count or Block for action. | `map` | n/a | yes |
| hex\_id | This was legacy id used in cloudformation track | `string` | n/a | yes |
| ipset\_block | Block the specific IPs, use Count or Block for action. | `map` | n/a | yes |
| ipset\_rate\_limit | Rate-limit the specific IPs, use Count or Block for action. | `map` | n/a | yes |
| logging\_to\_es | (Optional) Logging to ES, default to false. | `bool` | `false` | no |
| logging\_to\_es\_domain\_arn | The ARN of ES Domain is required is logging\_to\_es is true. | `string` | `""` | no |
| logging\_to\_es\_firehose\_buffer\_interval | The firehose\_buffer\_interval is required if `logging_to_es` is true. | `number` | `300` | no |
| logging\_to\_es\_firehose\_buffer\_size | The firehose\_buffer\_size is required if `logging_to_es` is true. | `number` | `15` | no |
| logging\_to\_es\_index\_name | The index\_name for ES is required if `logging_to_es` is true. | `string` | `""` | no |
| logging\_to\_es\_index\_rotation | The index\_rotation of ES is required if `logging_to_es` is true. | `string` | `"OneWeek"` | no |
| logging\_to\_es\_index\_type | The index\_type of ES is required if `logging_to_es` is true. | `string` | `""` | no |
| logging\_to\_es\_s3\_kms\_key\_arn | The KMS key for S3 encryption, required if `logging_to_es` is true. | `string` | `""` | no |
| logging\_to\_es\_sec\_grp\_id | The security group of ES is required if `logging_to_es` is true. | `set(string)` | `[]` | no |
| logging\_to\_es\_subnet\_ids | The subnet ids of ES is required if `logging_to_es` is true. | `set(string)` | `[]` | no |
| name | Name of WAFv2 | `string` | `""` | no |
| permissions\_boundary | Boundary required for GCC | `string` | `""` | no |
| rate\_limit\_ips | IPs to be rate-limited | `set(string)` | `[]` | no |
| s3\_bucket\_name | S3 Bucket for Logging | `string` | `""` | no |
| scope | Scope of WAFv2 | `string` | `"REGIONAL"` | no |
| tags | A map of tags to add to all resources | `map(string)` | <pre>{<br>  "Terraform": "True"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| wafv2\_arn | ARN of WAFv2 |


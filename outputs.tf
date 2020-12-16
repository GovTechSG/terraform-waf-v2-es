
// too lengthy, remove `.arn` if you want to see the full wafv2
output "wafv2_arn" {
  description = "ARN of WAFv2"
  value       = aws_wafv2_web_acl.main.arn
}

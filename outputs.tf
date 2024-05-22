
output "endpoint" {
  description = "Details of the Route53 Outbound Resolver endpoint."
  value       = aws_route53_resolver_endpoint.this
}

output "rules" {
  description = "Map of resolver rules by group."
  value       = aws_route53_resolver_rule.this
}

output "resource_shares" {
  description = "Map of AWS RAM Shares by group."
  value       = aws_ram_resource_share.this
}

output "all_resolver_rules" {
  description = "Map of all resolver rules."
  value       = local.all_resolver_rules_by_share
}

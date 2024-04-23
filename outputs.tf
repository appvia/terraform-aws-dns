output "endpoint" {
  value       = aws_route53_resolver_endpoint.this
  description = "Details of the Route53 Outbound Resolver endpoint."
}

output "rules" {
  value       = aws_route53_resolver_rule.this
  description = "Map of resolver rules by group."
}

output "resource_shares" {
  value       = aws_ram_resource_share.this
  description = "Map of AWS RAM Shares by group."
}

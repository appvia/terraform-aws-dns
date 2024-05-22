
## Provision the RAM resource share
resource "aws_ram_resource_share" "this" {
  for_each = local.all_resolver_rules_by_name

  name                      = each.key
  allow_external_principals = false
  tags                      = merge(var.tags, { Name = each.key })
}

## We need to associate the resource to the resource share 
resource "aws_ram_resource_association" "this" {
  for_each = local.all_resolver_rules_by_name

  resource_arn       = aws_route53_resolver_rule.this[each.key].arn
  resource_share_arn = aws_ram_resource_share.this[each.key].arn

  depends_on = [
    aws_route53_resolver_rule.this,
    aws_ram_resource_share.this
  ]
}

## Provision the associations for the principals
resource "aws_ram_principal_association" "this" {
  for_each = local.all_resolver_rules_by_share

  principal          = each.value.principal
  resource_share_arn = aws_ram_resource_share.this[each.value.ram_share_name].arn
}

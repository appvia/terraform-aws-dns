resource "aws_security_group" "this" {
  name        = "${var.resolver_name}-sg"
  description = "Security group for the ${var.resolver_name} resolver endpoint"
  vpc_id      = var.resolver_vpc_id

  tags = merge(var.tags, {
    Name = var.resolver_name
  })
}

resource "aws_route53_resolver_endpoint" "this" {
  name                   = var.resolver_name
  resolver_endpoint_type = var.resolver_endpoint_type
  protocols              = var.resolver_protocols
  direction              = "OUTBOUND"

  security_group_ids = [
    aws_security_group.this.id,
  ]

  dynamic "ip_address" {
    for_each = toset(var.resolver_subnet_ids)

    content {
      subnet_id = ip_address.value
    }
  }
}

resource "aws_route53_resolver_rule" "this" {
  for_each = local.normalised_rules

  name        = each.value.name
  domain_name = each.value.domain
  rule_type   = "FORWARD"

  resolver_endpoint_id = aws_route53_resolver_endpoint.this.id

  dynamic "target_ip" {
    for_each = each.value.targets

    content {
      ip = target_ip.value
    }
  }

  tags = merge(var.tags, {
    Name = var.resolver_name
  })
}

resource "aws_route53_zone_association" "this" {
  for_each = toset(var.route53_zone_ids)

  vpc_id  = var.resolver_vpc_id
  zone_id = each.value
}

resource "aws_ram_resource_share" "this" {
  for_each = local.normalised_rule_groups

  name                      = format("%s-resolver", each.value.name)
  allow_external_principals = false

  tags = merge(var.tags, {
    Name = each.value.name
  })
}

resource "aws_ram_resource_association" "this" {
  for_each = local.normalised_rules

  resource_arn       = aws_route53_resolver_rule.this[each.key].arn
  resource_share_arn = aws_ram_resource_share.this[each.value.group].arn
}

resource "aws_ram_principal_association" "this" {
  for_each = merge([
    for k, v in local.normalised_rule_groups : {
      for p in v.ram_principals :
      join("-", [k, p]) => {
        group     = k
        principal = p
      }
    }
  ]...)

  principal          = each.value.principal
  resource_share_arn = aws_ram_resource_share.this[each.value.group].arn
}

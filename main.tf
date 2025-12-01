
## Provision the network is required
module "vpc" {
  count   = local.enable_vpc_creation ? 1 : 0
  source  = "appvia/network/aws"
  version = "0.6.14"

  availability_zones                     = var.network.availability_zones
  enable_default_route_table_association = var.network.enable_default_route_table_association
  enable_default_route_table_propagation = var.network.enable_default_route_table_propagation
  ipam_pool_id                           = var.network.ipam_pool_id
  name                                   = var.network.name
  private_subnet_netmask                 = var.network.private_netmask
  tags                                   = var.tags
  transit_gateway_id                     = var.network.transit_gateway_id
  vpc_cidr                               = var.network.vpc_cidr
  vpc_netmask                            = var.network.vpc_netmask
}

## If we are provisioning the resolvers we need to create a security group to allow the dns traffic
# tfsec:ignore:aws-ec2-no-public-egress-sgr
module "dns_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.1"

  name                = local.security_group_name
  description         = "Used by the Route53 Resolver to allow DNS traffic to the internal dns solution"
  ingress_cidr_blocks = ["10.0.0.0/8"]
  ingress_rules       = ["dns-tcp", "dns-udp"]
  egress_rules        = ["dns-tcp", "dns-udp"]
  tags                = merge(var.tags, { "Name" : local.security_group_name })
  vpc_id              = local.vpc_id
}

## Provision the Route53 resolver endpoint within the VPC
resource "aws_route53_resolver_endpoint" "this" {
  name                   = var.resolver_name
  direction              = "OUTBOUND"
  protocols              = var.resolver_protocols
  resolver_endpoint_type = var.resolver_endpoint_type
  security_group_ids     = [module.dns_security_group.security_group_id]
  tags                   = merge(var.tags, { Name = var.resolver_name })

  dynamic "ip_address" {
    for_each = toset(local.subnet_ids)

    content {
      subnet_id = ip_address.value
    }
  }
}

## Provision the Route53 resolver rules and associate them with the resolver endpoint
resource "aws_route53_resolver_rule" "this" {
  for_each = local.all_resolver_rules_by_name

  name                 = each.value.rule_name
  domain_name          = each.value.domain
  resolver_endpoint_id = aws_route53_resolver_endpoint.this.id
  rule_type            = "FORWARD"
  tags                 = merge(var.tags, { Name = each.value.rule_name })

  dynamic "target_ip" {
    ## If we have a list of targets use them, otherwise use the default vpc resolver
    for_each = length(each.value.targets) > 0 ? each.value.targets : [local.vpc_dns_resolver]

    content {
      ip = target_ip.value
    }
  }
}

## Associate the Route53 resolver endpoint with the VPC
resource "aws_route53_zone_association" "this" {
  for_each = toset(var.route53_zone_ids)

  vpc_id  = local.vpc_id
  zone_id = each.value
}

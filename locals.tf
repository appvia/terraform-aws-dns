
locals {
  ## Indicates if we should provision a VPC for the solution to live in
  enable_vpc_creation = var.network.create

  ## Is the vpc id we are using; this will be either the one we are creating, or reusing
  vpc_id = local.enable_vpc_creation ? module.vpc[0].vpc_id : var.network.vpc_id
  ## Is the vpc cidr range we are using; this will be either the one we are creating, or reusing
  vpc_cidr = local.enable_vpc_creation ? module.vpc[0].vpc_cidr : var.network.vpc_cidr
  ## Is the local dns resolver ip address
  vpc_dns_resolver = local.enable_vpc_creation ? cidrhost(local.vpc_cidr, 2) : cidrhost(var.network.vpc_cidr, 2)
  ## Is a list of private subnet id, where to place the outbound resolver
  subnet_ids = local.enable_vpc_creation ? module.vpc[0].private_subnet_ids : var.network.private_subnet_ids

  ## Is the name of the security group used by the dns resolvers
  security_group_name = "dns-resolvers-${var.resolver_name}"

  ## We create a map for all the resolver rules by their rule name
  all_resolver_rules_by_name = merge([
    for k, v in var.resolver_rule_groups : {
      for rule in v.rules :
      format("%s-%s", v.ram_share_name, rule.name) => {
        domain     = rule.domain
        principals = values(v.ram_principals)
        rule_name  = rule.name
        rule_type  = rule.rule_type
        targets    = rule.targets
      }
    }
  ]...)

  all_resolver_rules_by_share = merge([
    for k, v in local.all_resolver_rules_by_name : {
      for principal in v.principals :
      format("%s-%s", k, principal) => {
        principal      = principal
        ram_share_name = k
      }
    }
  ]...)
}

#####################################################################################
# Terraform module examples are meant to show an _example_ on how to use a module
# per use-case. The code below should not be copied directly but referenced in order
# to build your own root module that invokes this module
#####################################################################################

## Create a network for the endpoints to reuse 
module "network" {
  source  = "appvia/network/aws"
  version = "0.3.0"

  availability_zones                    = 2
  enable_ipam                           = true
  enable_route53_resolver_rules         = true
  enable_transit_gateway                = true
  enable_transit_gateway_appliance_mode = true
  ipam_pool_id                          = var.ipam_pool_id
  name                                  = "central-dns"
  private_subnet_netmask                = 24
  tags                                  = var.tags
  transit_gateway_id                    = var.transit_gateway_id
  vpc_netmask                           = 21
}

module "dns" {
  source = "../../"

  resolver_name = "outbound-central-dns"
  tags          = var.tags

  resolver_rule_groups = [
    {
      ram_share_name = "internal"
      ram_principals = {
        "Deployments" = "arn:aws:organizations::536471746696:ou/o-7enwqk0f2c/ou-1tbg-mq4w830q"
        "Workloads"   = "arn:aws:organizations::536471746696:ou/o-7enwqk0f2c/ou-1tbg-lk6g79d4"
      }
      rules = [
        {
          name   = "aws-appvia-local"
          domain = "aws.appvia.local"
        }
      ]
    }
  ]

  network = {
    availability_zones = 2
    create             = false
    private_subnet_ids = module.network.private_subnet_ids
    transit_gateway_id = var.transit_gateway_id
    vpc_cidr           = module.network.vpc_cidr
    vpc_id             = module.network.vpc_id
  }
}


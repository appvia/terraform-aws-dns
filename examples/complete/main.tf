#####################################################################################
# Terraform module examples are meant to show an _example_ on how to use a module
# per use-case. The code below should not be copied directly but referenced in order
# to build your own root module that invokes this module
#####################################################################################

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
    transit_gateway_id = var.transit_gateway_id
    private_netmask    = 24
    vpc_cidr           = "10.90.0.0/21"
  }
}


locals {
  vpc_provided_dns = "10.0.0.2"
}

module "central_dns" {
  source = "../../"

  resolver_name = "central"

  # ID of the VPC where the outbound resolver should be created.
  resolver_vpc_id = "vpc-0f839083ca150be0f"

  # At least 2 subnets (in different AZs) where the outbound resolver endpoints
  # will be created.
  resolver_subnet_ids = [
    "subnet-05268db2ad256445e",
    "subnet-0e52076f0f87ba47d",
  ]

  # We define our resolver rules in groups. For each group we define we add the rules
  # defined to an AWS RAM resource share and share with the defined principals.
  resolver_rule_groups = {
    main = {
      # Name is optional and defaults to the key of the map if not defined.
      name = "MyCompany"

      # List of principal ARNs to share the RAM share with.
      ram_principals = [
        "arn:aws:organizations::012345678910:organization/o-6doxpl2e1d",
      ]

      # List of rule definitions
      rules = [{
        # Domain name for which we want to forward rules. Domains specified here are inclusive
        # of the domain itself and all subdomains.
        domain = "mycompany.internal"

        # List of IP addresses that will resolve the query for this domain. For utilising Route53
        # private hosted zones, this should be the Amazon provided DNS server address for the VPC.
        targets = [
          local.vpc_provided_dns,
        ]
      }]
    }
  }

  # In order to resolve DNS queries for private hosted zones that exist in other accounts
  # we need to associate those zones with the VPC that we're creating our resolver. You
  # must ensure that the zones specified below are pre-authorized to be associated with
  # the VPC specified in `resolver_vpc_id`.
  route53_zone_ids = [
    "Z069099416OO53SIZNSAH",
    "Z0104059RZRYA0EE84IM",
    "Z082763213W4KUUPYB6YW",
    "Z04370363H60F9DXTVYIU",
  ]
}

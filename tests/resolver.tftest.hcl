
mock_provider "aws" {
  mock_data "aws_availability_zones" {
    defaults = {
      group_names = []
      names       = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
    }
  }
}

run "resolver_sharing" {
  command = plan

  variables {
    resolver_name = "test"
    tags = {
      Environment = "Test"
    }

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
      name               = "test"
      availability_zones = 2
      vpc_cidr           = "10.90.0.0/21"
      transit_gateway_id = "tgw-12222222"
    }
  }

  assert {
    condition     = length(aws_ram_principal_association.this) == length(var.resolver_rule_groups[0].ram_principals)
    error_message = "Expected the correct number of RAM principal associations"
  }
}

run "resolver_creation" {
  command = plan

  variables {
    resolver_name = "test"
    tags = {
      Environment = "Test"
    }

    resolver_rule_groups = [
      {
        ram_share_name = "internal"
        ram_principals = {}
        rules = [
          {
            name   = "aws-appvia-local"
            domain = "aws.appvia.local"
          }
        ]
      }
    ]

    network = {
      name               = "test"
      availability_zones = 2
      vpc_cidr           = "10.90.0.0/21"
      transit_gateway_id = "tgw-12222222"
    }
  }

  assert {
    condition     = aws_route53_resolver_endpoint.this.name == var.resolver_name
    error_message = "Name of the resolver is incorrect"
  }

  assert {
    condition     = length(aws_route53_resolver_endpoint.this.protocols) == length(var.resolver_protocols)
    error_message = "Expected protocols to be set"
  }

  assert {
    condition     = aws_route53_resolver_endpoint.this.resolver_endpoint_type == var.resolver_endpoint_type
    error_message = "Expected resolver endpoint type to be set"
  }

  assert {
    condition     = aws_route53_resolver_endpoint.this.direction == "OUTBOUND"
    error_message = "Expected an outbound resolver"
  }

  assert {
    condition     = module.dns_security_group.aws_security_group.this_name_prefix[0].name_prefix == "dns-resolvers-test"
    error_message = "Expected security group to be created"
  }
}

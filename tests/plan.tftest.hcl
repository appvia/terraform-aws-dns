
mock_provider "aws" {
  mock_data "aws_availability_zones" {
    defaults = {
      group_names = []
      names       = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
    }
  }
}

# Ensure the plan runs successfully
run "plan" {
  command = plan

  variables {
    resolver_name = "test"
    tags = {
      Environment = "Test"
    }

    resolver_rule_groups = []

    network = {
      availability_zones = 2
      vpc_cidr           = "10.90.0.0/21"
      transit_gateway_id = "tgw-12222222"
    }
  }
}


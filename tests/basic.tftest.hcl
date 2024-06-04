mock_provider "aws" {
  mock_data "aws_availability_zones" {
    defaults = {
      names = [
        "eu-west-1a",
        "eu-west-1b",
        "eu-west-1c"
      ]
    }
  }
}

run "basic_resolver" {
  command = plan

  variables {
    resolver_name      = "test"
    resolver_protocols = ["Do53"]
    network = {
      vpc_cidr           = "10.90.0.0/21"
      transit_gateway_id = "tgw-04ad8f026be8b7eb6"
    }
    tags = {
      "Environment" = "Testing"
      "GitRepo"     = "https://github.com/appvia/terraform-aws-dns"
    }
  }

  assert {
    condition     = aws_route53_resolver_endpoint.this.direction == "OUTBOUND"
    error_message = "Endpoint direction incorrect"
  }

  assert {
    condition     = length(aws_route53_resolver_endpoint.this.protocols) == 1
    error_message = "Only one protocol expected to be defined"
  }

  assert {
    condition     = contains(aws_route53_resolver_endpoint.this.protocols, "Do53")
    error_message = "Resolver endpoint should contain Do53 protocol"
  }

  assert {
    condition     = aws_route53_resolver_endpoint.this.resolver_endpoint_type == "IPV4"
    error_message = "Resolver endpoint type should be IPV4"
  }
}

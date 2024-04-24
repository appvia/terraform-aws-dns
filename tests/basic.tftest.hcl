mock_provider "aws" {

}

run "basic_resolver" {
  command = plan

  variables {
    resolver_name   = "test"
    resolver_vpc_id = "vpc-abc123"

    resolver_subnet_ids = [
      "subnet-abc123",
      "subnet-def456",
    ]
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

  assert {
    condition     = aws_security_group.this.name == "${var.resolver_name}-sg"
    error_message = "Expected security group name to have -sg suffix"
  }
}

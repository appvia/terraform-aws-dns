<!-- markdownlint-disable -->

<a href="https://www.appvia.io/"><img src="https://github.com/appvia/terraform-aws-dns/blob/main/docs/banner.jpg?raw=true" alt="Appvia Banner"/></a><br/><p align="right"> <a href="https://registry.terraform.io/modules/appvia/dns/aws/latest"><img src="https://img.shields.io/static/v1?label=APPVIA&message=Terraform%20Registry&color=191970&style=for-the-badge" alt="Terraform Registry"/></a></a> <a href="https://github.com/appvia/terraform-aws-dns/releases/latest"><img src="https://img.shields.io/github/release/appvia/terraform-aws-dns.svg?style=for-the-badge&color=006400" alt="Latest Release"/></a> <a href="https://appvia-community.slack.com/join/shared_invite/zt-1s7i7xy85-T155drryqU56emm09ojMVA#/shared-invite/email"><img src="https://img.shields.io/badge/Slack-Join%20Community-purple?style=for-the-badge&logo=slack" alt="Slack Community"/></a> <a href="https://github.com/appvia/terraform-aws-dns/graphs/contributors"><img src="https://img.shields.io/github/contributors/appvia/terraform-aws-dns.svg?style=for-the-badge&color=FF8C00" alt="Contributors"/></a>

<!-- markdownlint-restore -->
<!--
  ***** CAUTION: DO NOT EDIT ABOVE THIS LINE ******
-->

![Github Actions](https://github.com/appvia/terraform-aws-dns/actions/workflows/terraform.yml/badge.svg)

# Terraform AWS Central DNS

## Overview

The Terraform AWS Central DNS module provides a comprehensive solution for managing centralized DNS resolution across AWS Organizations. This module creates and manages Route 53 Resolver endpoints, rules, and AWS Resource Access Manager (RAM) shares to enable seamless DNS resolution between private hosted zones across multiple AWS accounts and organizational units.

## Purpose & Intent

### **Problem Statement**

In large AWS Organizations with multiple accounts and organizational units, DNS resolution becomes increasingly complex:

- **Fragmented DNS Resolution**: Each account maintains its own private hosted zones, creating isolated DNS namespaces
- **Cross-Account DNS Challenges**: Applications in different accounts cannot resolve internal domain names from other accounts
- **Complex DNS Management**: Managing DNS rules and forwarding across multiple accounts requires significant operational overhead
- **Security and Compliance**: Ensuring secure DNS resolution while maintaining proper access controls across organizational boundaries
- **Scalability Issues**: As organizations grow, DNS management becomes increasingly complex and error-prone

### **Solution**

This module provides a centralized, scalable DNS solution that:

- **Centralizes DNS Management**: Creates a single point of DNS resolution for the entire organization
- **Enables Cross-Account Resolution**: Allows private hosted zones to resolve DNS queries across account boundaries
- **Simplifies DNS Operations**: Provides a unified interface for managing DNS rules and forwarding
- **Ensures Security**: Implements proper IAM controls and network security for DNS traffic
- **Scales with Organization**: Automatically shares DNS rules with specified organizational units via AWS RAM

## Key Features

### 🌐 **Centralized DNS Resolution**

- **Route 53 Resolver Endpoints**: Creates outbound resolver endpoints for DNS forwarding
- **Cross-Account DNS Support**: Enables DNS resolution between private hosted zones across accounts
- **Multi-Protocol Support**: Supports both Do53 (DNS over port 53) and DoH (DNS over HTTPS) protocols
- **IPv4/IPv6 Support**: Configurable IP address types (IPv4, IPv6, or dual-stack)

### 🔄 **Flexible Network Architecture**

- **VPC Creation or Reuse**: Option to create new VPC or reuse existing network infrastructure
- **Transit Gateway Integration**: Seamless integration with AWS Transit Gateway for multi-VPC connectivity
- **IPAM Support**: Integration with AWS IP Address Manager for IP allocation
- **Multi-AZ Deployment**: Ensures high availability across multiple availability zones

### 🔐 **Secure Resource Sharing**

- **AWS RAM Integration**: Shares DNS resolver rules with organizational units via Resource Access Manager
- **Principals Management**: Configurable sharing with specific OUs, accounts, or external principals
- **Access Control**: Granular control over which resources can access specific DNS rules
- **External Principal Support**: Optional support for sharing with external AWS accounts

### 📊 **Advanced DNS Management**

- **Rule Groups**: Organize DNS rules into logical groups for better management
- **Custom Targets**: Configurable DNS forwarding targets (defaults to VPC DNS resolver)
- **Zone Associations**: Associate Route 53 private hosted zones with the resolver VPC
- **Rule Types**: Support for different resolver rule types (currently FORWARD)

### 🛡️ **Security & Compliance**

- **Security Groups**: Automatically configured security groups for DNS traffic
- **Network Isolation**: DNS traffic restricted to private subnets and internal networks
- **IAM Integration**: Proper IAM roles and permissions for all resources
- **Audit Trail**: Comprehensive logging and monitoring capabilities

### ⚙️ **Operational Excellence**

- **Terraform State Management**: Full Terraform state management for all resources
- **Resource Tagging**: Consistent tagging across all created resources
- **Output Management**: Comprehensive outputs for integration with other modules
- **Dependency Management**: Proper resource dependencies and lifecycle management

## Usage

```hcl
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
```

## Update Documentation

The `terraform-docs` utility is used to generate this README. Follow the below steps to update:

1. Make changes to the `.terraform-docs.yml` file
2. Fetch the `terraform-docs` binary (<https://terraform-docs.io/user-guide/installation/>)
3. Run `terraform-docs markdown table --output-file ${PWD}/README.md --output-mode inject .`

<!-- BEGIN_TF_DOCS -->
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_network"></a> [network](#input\_network) | The network to use for the endpoints and optinal resolvers | <pre>object({<br/>    availability_zones = optional(number, 2)<br/>    # Whether to use ipam when creating the network<br/>    create = optional(bool, true)<br/>    # Indicates if we should create a new network or reuse an existing one<br/>    enable_default_route_table_association = optional(bool, true)<br/>    # Whether to associate the default route table  <br/>    enable_default_route_table_propagation = optional(bool, true)<br/>    # Whether to propagate the default route table<br/>    ipam_pool_id = optional(string, null)<br/>    # The id of the ipam pool to use when creating the network<br/>    name = optional(string, "central-dns")<br/>    # The name of the network to create<br/>    private_netmask = optional(number, 24)<br/>    # The subnet mask for private subnets, when creating the network i.e subnet-id => 10.90.0.0/24<br/>    private_subnet_ids = optional(list(string), [])<br/>    # The ids of the private subnets to if we are reusing an existing network<br/>    transit_gateway_id = optional(string, "")<br/>    ## The transit gateway id to use for the network<br/>    vpc_cidr = optional(string, "")<br/>    # The cidrws range to use for the VPC, when creating the network<br/>    vpc_id = optional(string, "")<br/>    # The vpc id to use when reusing an existing network <br/>    vpc_netmask = optional(number, null)<br/>    # When using ipam this the netmask to use for the VPC<br/>  })</pre> | n/a | yes |
| <a name="input_resolver_name"></a> [resolver\_name](#input\_resolver\_name) | Name of the Route53 resolver endpoint | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags to apply to resources created by this module | `map(string)` | n/a | yes |
| <a name="input_resolver_endpoint_type"></a> [resolver\_endpoint\_type](#input\_resolver\_endpoint\_type) | The Route 53 Resolver endpoint IP address type. Valid values: IPV4, IPV6, DUALSTACK. | `string` | `"IPV4"` | no |
| <a name="input_resolver_protocols"></a> [resolver\_protocols](#input\_resolver\_protocols) | List of protocols that the Route53 Outbound Resolver should support | `list(string)` | <pre>[<br/>  "Do53",<br/>  "DoH"<br/>]</pre> | no |
| <a name="input_resolver_rule_groups"></a> [resolver\_rule\_groups](#input\_resolver\_rule\_groups) | Map of Route53 Resolver Rules by group. Every rule in each group can be shared with principals via AWS RAM. | <pre>list(object({<br/>    ram_share_name = string<br/>    # The share share name will be the ram_share_name '-' rule_name<br/>    ram_principals = optional(map(string), {})<br/>    ## A map of principals to share the rules with i.e. Infrastructure OU => ou-1234567890<br/>    rules = list(object({<br/>      name = string<br/>      ## The name of the rule, used when creating the ram share <br/>      domain = string<br/>      ## The domain to forward the query to <br/>      targets = optional(list(string), [])<br/>      ## The name of the resolver rule<br/>      rule_type = optional(string, "FORWARD")<br/>      ## The type of rule to create <br/>    }))<br/>    ## A list of rules to create in the group <br/>  }))</pre> | `[]` | no |
| <a name="input_route53_zone_ids"></a> [route53\_zone\_ids](#input\_route53\_zone\_ids) | List of Route53 Zone IDs to be associated with the resolver VPC. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_all_resolver_rules"></a> [all\_resolver\_rules](#output\_all\_resolver\_rules) | Map of all resolver rules. |
| <a name="output_endpoint"></a> [endpoint](#output\_endpoint) | Details of the Route53 Outbound Resolver endpoint. |
| <a name="output_resource_shares"></a> [resource\_shares](#output\_resource\_shares) | Map of AWS RAM Shares by group. |
| <a name="output_rules"></a> [rules](#output\_rules) | Map of resolver rules by group. |
<!-- END_TF_DOCS -->

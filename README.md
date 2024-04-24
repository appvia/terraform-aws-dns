![Github Actions](../../actions/workflows/terraform.yml/badge.svg)

# Terraform <NAME>

## Description

Add a description of the module here

## Usage

Add example usage here

```hcl
module "example" {
  source  = "appvia/dns/aws"
  version = "1.0.0"

  # insert variables here
}
```

## Update Documentation

The `terraform-docs` utility is used to generate this README. Follow the below steps to update:

1. Make changes to the `.terraform-docs.yml` file
2. Fetch the `terraform-docs` binary (https://terraform-docs.io/user-guide/installation/)
3. Run `terraform-docs markdown table --output-file ${PWD}/README.md --output-mode inject .`

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.7 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ram_principal_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_principal_association) | resource |
| [aws_ram_resource_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_resource_association) | resource |
| [aws_ram_resource_share.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_resource_share) | resource |
| [aws_route53_resolver_endpoint.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_endpoint) | resource |
| [aws_route53_resolver_rule.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_rule) | resource |
| [aws_route53_zone_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone_association) | resource |
| [aws_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_resolver_name"></a> [resolver\_name](#input\_resolver\_name) | Name of the Route53 resolver endpoint | `string` | n/a | yes |
| <a name="input_resolver_subnet_ids"></a> [resolver\_subnet\_ids](#input\_resolver\_subnet\_ids) | List of subnet IDs in which to create the Route53 Outbound Resolver | `list(string)` | n/a | yes |
| <a name="input_resolver_vpc_id"></a> [resolver\_vpc\_id](#input\_resolver\_vpc\_id) | The ID of the VPC in which to create the Route53 Outbound Resolver | `string` | n/a | yes |
| <a name="input_resolver_endpoint_type"></a> [resolver\_endpoint\_type](#input\_resolver\_endpoint\_type) | The Route 53 Resolver endpoint IP address type. Valid values: IPV4, IPV6, DUALSTACK. | `string` | `"IPV4"` | no |
| <a name="input_resolver_protocols"></a> [resolver\_protocols](#input\_resolver\_protocols) | List of protocols that the Route53 Outbound Resolver should support | `list(string)` | <pre>[<br>  "Do53"<br>]</pre> | no |
| <a name="input_resolver_rule_groups"></a> [resolver\_rule\_groups](#input\_resolver\_rule\_groups) | Map of Route53 Resolver Rules by group. Every rule in each group can be shared with principals via AWS RAM. | <pre>map(object({<br>    name           = optional(string)<br>    ram_principals = optional(list(string), [])<br><br>    rules = list(object({<br>      domain    = string<br>      targets   = list(string)<br>      name      = optional(string)<br>      rule_type = optional(string, "FORWARD")<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_route53_zone_ids"></a> [route53\_zone\_ids](#input\_route53\_zone\_ids) | List of Route53 Zone IDs to be associated with the resolver VPC. | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags to apply to resources created by this module | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_endpoint"></a> [endpoint](#output\_endpoint) | Details of the Route53 Outbound Resolver endpoint. |
| <a name="output_resource_shares"></a> [resource\_shares](#output\_resource\_shares) | Map of AWS RAM Shares by group. |
| <a name="output_rules"></a> [rules](#output\_rules) | Map of resolver rules by group. |
<!-- END_TF_DOCS -->

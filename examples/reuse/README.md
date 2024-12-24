# Reuse Existing VPC

In order to reuse and existing VPC, the module requires to following inputs

- `var.network.transit_gateway_id` - The id of the transit gateway to use for the network.
- `var.network.vpc_id` - The id of the VPC to use for the network.
- `var.network.vpc_cidr` - The CIDR block of the VPC to use for the network.
- `var.network.subnet_ids` - The list subnet ids for the private subnets.

<!-- BEGIN_TF_DOCS -->
## Providers

No providers.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ipam_pool_id"></a> [ipam\_pool\_id](#input\_ipam\_pool\_id) | The id of the ipam pool to use when creating the network | `string` | `"ipam-pool-054836edbcccd8983"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags to apply to resources created by this module | `map(string)` | <pre>{<br/>  "Environment": "Testing",<br/>  "GitRepo": "https://github.com/appvia/terraform-aws-dns"<br/>}</pre> | no |
| <a name="input_transit_gateway_id"></a> [transit\_gateway\_id](#input\_transit\_gateway\_id) | The id of the transit gateway to use for the network | `string` | `"tgw-04ad8f026be8b7eb6"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->


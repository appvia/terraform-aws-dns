<!-- BEGIN_TF_DOCS -->
## Providers

No providers.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags to apply to resources created by this module | `map(string)` | <pre>{<br/>  "Environment": "Testing",<br/>  "GitRepo": "https://github.com/appvia/terraform-aws-dns"<br/>}</pre> | no |
| <a name="input_transit_gateway_id"></a> [transit\_gateway\_id](#input\_transit\_gateway\_id) | The id of the transit gateway to use for the network | `string` | `"tgw-04ad8f026be8b7eb6"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
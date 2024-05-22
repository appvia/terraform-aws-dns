<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_dns"></a> [dns](#module\_dns) | ../../ | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags to apply to resources created by this module | `map(string)` | <pre>{<br>  "Environment": "Testing",<br>  "GitRepo": "https://github.com/appvia/terraform-aws-dns"<br>}</pre> | no |
| <a name="input_transit_gateway_id"></a> [transit\_gateway\_id](#input\_transit\_gateway\_id) | The id of the transit gateway to use for the network | `string` | `"tgw-04ad8f026be8b7eb6"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
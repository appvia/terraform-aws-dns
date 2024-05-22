
variable "tags" {
  description = "Map of tags to apply to resources created by this module"
  type        = map(string)
  default = {
    "Environment" = "Testing"
    "GitRepo"     = "https://github.com/appvia/terraform-aws-dns"
  }
}

variable "ipam_pool_id" {
  description = "The id of the ipam pool to use when creating the network"
  type        = string
  default     = "ipam-pool-054836edbcccd8983"
}

variable "transit_gateway_id" {
  description = "The id of the transit gateway to use for the network"
  type        = string
  default     = "tgw-04ad8f026be8b7eb6"
}


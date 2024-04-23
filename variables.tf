variable "resolver_name" {
  type        = string
  description = "Name of the Route53 resolver endpoint"
}

variable "resolver_vpc_id" {
  type        = string
  description = "The ID of the VPC in which to create the Route53 Outbound Resolver"
}

variable "resolver_subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs in which to create the Route53 Outbound Resolver"
}

variable "resolver_protocols" {
  type = list(string)
  default = [
    "Do53",
  ]
  description = "List of protocols that the Route53 Outbound Resolver should support"
}

variable "resolver_endpoint_type" {
  type        = string
  default     = "IPV4"
  description = "The Route 53 Resolver endpoint IP address type. Valid values: IPV4, IPV6, DUALSTACK."
}

variable "resolver_rule_groups" {
  type = map(object({
    name           = optional(string)
    ram_principals = optional(list(string), [])

    rules = list(object({
      domain    = string
      targets   = list(string)
      name      = optional(string)
      rule_type = optional(string, "FORWARD")
    }))
  }))

  default     = {}
  description = "Map of Route53 Resolver Rules by group. Every rule in each group can be shared with principals via AWS RAM."
}

variable "route53_zone_ids" {
  type        = list(string)
  default     = []
  description = "List of Route53 Zone IDs to be associated with the resolver VPC."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Map of tags to apply to resources created by this module"
}

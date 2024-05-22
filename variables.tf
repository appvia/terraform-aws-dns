variable "resolver_name" {
  description = "Name of the Route53 resolver endpoint"
  type        = string
}

variable "resolver_protocols" {
  description = "List of protocols that the Route53 Outbound Resolver should support"
  type        = list(string)
  default     = ["Do53", "DoH"]
}

variable "resolver_endpoint_type" {
  description = "The Route 53 Resolver endpoint IP address type. Valid values: IPV4, IPV6, DUALSTACK."
  type        = string
  default     = "IPV4"
}

variable "resolver_rule_groups" {
  description = "Map of Route53 Resolver Rules by group. Every rule in each group can be shared with principals via AWS RAM."
  type = list(object({
    ram_share_name = string
    # The share share name will be the ram_share_name '-' rule_name
    ram_principals = optional(map(string), {})
    ## A map of principals to share the rules with i.e. Infrastructure OU => ou-1234567890
    rules = list(object({
      name = string
      ## The name of the rule, used when creating the ram share 
      domain = string
      ## The domain to forward the query to 
      targets = optional(list(string), [])
      ## The name of the resolver rule
      rule_type = optional(string, "FORWARD")
      ## The type of rule to create 
    }))
    ## A list of rules to create in the group 
  }))
  default = []
}

variable "network" {
  description = "The network to use for the endpoints and optinal resolvers"
  type = object({
    availability_zones = optional(number, 2)
    # Whether to use ipam when creating the network
    create = optional(bool, true)
    # Indicates if we should create a new network or reuse an existing one
    enable_default_route_table_association = optional(bool, true)
    # Whether to associate the default route table  
    enable_default_route_table_propagation = optional(bool, true)
    # Whether to propagate the default route table
    ipam_pool_id = optional(string, null)
    # The id of the ipam pool to use when creating the network
    name = optional(string, "central-dns")
    # The name of the network to create
    private_netmask = optional(number, 24)
    # The subnet mask for private subnets, when creating the network i.e subnet-id => 10.90.0.0/24
    private_subnet_ids = optional(list(string), [])
    # The ids of the private subnets to if we are reusing an existing network
    transit_gateway_id = optional(string, "")
    ## The transit gateway id to use for the network
    vpc_cidr = optional(string, "")
    # The cidrws range to use for the VPC, when creating the network
    vpc_id = optional(string, "")
    # The vpc id to use when reusing an existing network 
    vpc_netmask = optional(number, null)
    # When using ipam this the netmask to use for the VPC
  })
}

variable "route53_zone_ids" {
  description = "List of Route53 Zone IDs to be associated with the resolver VPC."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Map of tags to apply to resources created by this module"
  type        = map(string)
}

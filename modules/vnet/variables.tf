variable resource_group_name {
  description = "Resource Group name"
  type        = string
}

variable location {
  description = "Location in which to deploy the network"
  type        = string
}

variable vnet_name {
  description = "VNET name"
  type        = string
}

variable address_space {
  description = "VNET address space"
  type        = list(string)
}

variable subnets {
  description = "Subnets configuration"
  type = list(object({
    name             = string
    address_prefixes = list(string)
  }))
}

variable "subnet_enforce_private_link_endpoint_network_policies" {
  description = "A map with key (string) `subnet name`, value (bool) `true` or `false` to indicate enable or disable network policies for the private link endpoint on the subnet. Default value is false."
  type = map(bool)
    default = {private-endpoint-subnet:true}
}
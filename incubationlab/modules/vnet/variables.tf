variable "resource_group_name" {
  description = "Resource Group name"
  type        = string
}

variable "location" {
  description = "Location in which to deploy the network"
  type        = string
}

variable "nsg_name" {
  description = "nsg name"
  type        = string
}

variable "vnet_name" {
  description = "VNET name"
  type        = string
}

variable "vnet_address_range" {
  description = "VNET address space"
  type        = list(string)
  default = [ "10.0.0.0/8" ]
}

variable "subnet_name" {
  description = "subnet name"
  type        = string

}
variable "subnet_address_range" {
  description = "VNET address space"
  type        = list(string)
  default = [ "10.240.0.0/16" ]
}


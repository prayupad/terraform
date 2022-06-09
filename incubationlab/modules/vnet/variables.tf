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
  default = "labnsgpu"
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

variable "aks_subnet" {
  type        = string
  default = "lab-aks-subnet"

}
variable "akssubnet_address_range" {
  type        = list(string)
  default = [ "10.240.0.0/16" ]
}


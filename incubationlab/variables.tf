variable "location" {
  description = "The resource group location"
  default     = "eastus"
}

variable "tags" {
  description = "tags assigned to services"
}

variable "resource_group_name" {
  description = "The resource group name"
  default     = "plabrg"
}



/*variable "aks_user_assigned_identity" {
  description = "Name of the users and groups which need acces on KeyVault"
  type        = string
  default     = "epamaksusermsi"
} */

variable "keyvault_name" {
  description = "Name of the Key Vault to ceate key to encrypt/decrypt"
  type        = string
}


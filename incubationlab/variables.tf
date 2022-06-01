variable "location" {
  description = "The resource group location"
  default     = "eastus"
}

variable "tags" {
  default = "dev"
}

variable "resource_group_name" {
  description = "The resource group name"
  default     = "plabrg"
}

variable "log_analytics_workspace" {
  type = string
  default = "plogworkspace"
}



/*variable "aks_user_assigned_identity" {
  description = "Name of the users and groups which need acces on KeyVault"
  type        = string
  default     = "epamaksusermsi"
} */

/*
variable "keyvault_name" {
  description = "Name of the Key Vault to ceate key to encrypt/decrypt"
  type        = string
} */


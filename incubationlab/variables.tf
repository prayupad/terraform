variable "location" {
  description = "The resource group location"
  default     = "eastus"
}

variable "tags" {
  default = "dev"
}

variable "resource_group_name" {
  description = "The resource group name"
  default     = "labrgpu"
}


variable "aks_cluster_name" {
  default     = "labakspu"
}

variable "log_analytics_workspace" {
  type = string
  default = "logworkspacepu"
}

/*
variable "out_keyvault_id" {
  type = string
}


variable "key" {
  type = string
}

variable "secret" {
  type = string
}
*/


/*
variable "keyvault_name" {
  description = "Name of the Key Vault to ceate key to encrypt/decrypt"
  type        = string
} */



variable "kube_resource_group_name" {
  description = "Name of the resource group to create resources in rather than creating a new one. Used only for CI"
  type        = string
}
variable "keyvault_name" {
  description = "Name of the Key Vault to ceate key to encrypt/decrypt"
  type        = string
}

variable "location" {
  description = "Where the resources should live"
  type        = string
}

variable "tf_admin_users" {
  description = "Azure AD email addresses for users who should be able to access the Key Vault"
  type        = set(string)
}


variable "resource_group_name" {
  type        = string
}
variable "keyvault_name" {
  type        = string
}

variable "location" {
  type = string
}

variable "name" {
  type = string
  default = "ADadmin-pu"
}
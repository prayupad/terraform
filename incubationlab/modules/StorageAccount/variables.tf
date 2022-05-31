variable "resource_group_name" {
  description = "The name of the resource group in which the resources should live"
  type        = string
}

variable "location" {
  description = "Specifies the supported Azure location where the resource exists"
  type        = string
}

variable "name" {
  description = "Name of the storage account and bucket"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all relevant resources"
  type        = map(string)
  default     = {}
}



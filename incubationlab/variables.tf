variable "location" {
  description = "The resource group location"
  default     = "eastus2"
}

variable "tags" {
  description = "tags assigned to services"
}

variable "resource_group_name" {
  description = "The resource group name"
  default     = "apprg"
}

variable "vnet_name" {
  description = "AKS VNET name"
  default     = "aksvnet"
}

variable "enable_auto_scaling" {
  description = "Enable node pool autoscaling"
  type        = bool
  default     = true
}

variable "subnet_name" {
  description = "AKS Subnet name"
  default     = "aks-subnet"
}

#variable "private_endpoint_subnet_name" {
 # description = "Private endpoint subnet name"
  #default     = "private-endpoint-subnet"
#}



#variable "address_space" {
 # description = "VNET address space"
  #default     = "10.0.0.0/16"
#}



#variable "aks_subnet_address_space" {
 # description = "AKS subnet address space"
  #default     = "[10.0.1.0/24]"
#}


#variable "vm_subnet_address_space" {
 # description = "Jump vm subnet address space"
  #default     = "172.16.6.0/24"
#}

variable "aks_clustername" {
  description = "Name of the AKS cluster."
  default     = "epamakscluster"
}


variable "nodepool_nodes_count" {
  description = "Default nodepool nodes count"
  default     = 2
}

variable "nodepool_vm_size" {
  description = "Default nodepool VM size"
  default     = "Standard_D4s_v3"
}

variable "network_docker_bridge_cidr" {
  description = "CNI Docker bridge cidr"
  default     = "172.10.0.0/24"
}

variable "network_dns_service_ip" {
  description = "CNI DNS service IP"
  default     = "10.0.0.10"
}

variable "network_service_cidr" {
  description = "CNI service cidr"
  default     = "10.0.0.0/24"
}

#variable "server_name" {
 # description = "Specifies the name of the PostgreSQL Server. Changing this forces a new resource to be created."
  #type        = string
  #default = "postgrespoc"
#}

variable "sku_name" {
  description = "Specifies the SKU Name for this PostgreSQL Server. The name of the SKU, follows the tier + family + cores pattern (e.g. B_Gen4_1, GP_Gen5_8)."
  type        = string
  default     = "GP_Gen5_4"
}



variable "storage_account_name" {
  description = "Name of the storage account and bucket"
  type        = string
  default     = "epamstorage"
}

variable "sa_container_name" {
  description = "Name of the storage account and bucket"
  type        = string
  default     = "epamcontainer"
}

variable "tf_admin_users" {
  description = "Name of the users and groups which need acces on KeyVault"
  type        = set(string)
  default     = ["epamaksusermsi","SPN"]
}

variable "aks_user_assigned_identity" {
  description = "Name of the users and groups which need acces on KeyVault"
  type        = string
  default     = "epamaksusermsi"
}

variable "keyvault_name" {
  description = "Name of the Key Vault to ceate key to encrypt/decrypt"
  type        = string
  default     = "epamaksvault"
}

variable "acr_name" {
  description = "Name of the Azure Container Registry"
  type        = string
  default     = "epamacr"
}
variable "location" {
  description = "The resource group location"
  default     = "eastus2"
}

variable "kube_vnet_name" {
  description = "AKS VNET name"
  default     = "aksvnet"
}

variable "enable_auto_scaling" {
  description = "Enable node pool autoscaling"
  type        = bool
  default     = true
}

variable "aks_subnet_name" {
  description = "AKS Subnet name"
  default     = "aks-nodes-subnet"
}

variable "private_endpoint_subnet_name" {
  description = "Private endpoint subnet name"
  default     = "private-endpoint-subnet"
}
variable "bastion_subnet_name" {
  description = "Bastion Subnet name"
  default     = "bastion-subnet"
}

variable "vm_subnet_name" {
  description = "Jump VM Subnet name"
  default     = "jump-vm-subnet"
}

variable "address_space" {
  description = "VNET address space"
  default     = "172.16.0.0/12"
}

variable "private_endpoint_address_space" {
  description = "Private endpoint subnet address space"
  default     = "172.16.4.0/24"
}

variable "aks_subnet_address_space" {
  description = "AKS subnet address space"
  default     = "172.18.0.0/16"
}

variable "bastion_subnet_address_space" {
  description = "Bastion subnet address space"
  default     = "172.16.5.0/24"
}

variable "vm_subnet_address_space" {
  description = "Jump vm subnet address space"
  default     = "172.16.6.0/24"
}

variable "aks_cluster_name" {
  description = "Name of the AKS cluster."
  default     = "akspoc"
}

variable "kube_resource_group_name" {
  description = "The resource group name to be created"
  default     = "DINESH_POC_AKS_RG"
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
  default     = "172.17.0.1/16"
}

variable "network_dns_service_ip" {
  description = "CNI DNS service IP"
  default     = "172.16.0.10"
}

variable "network_service_cidr" {
  description = "CNI service cidr"
  default     = "172.16.0.0/22"
}

variable "server_name" {
  description = "Specifies the name of the PostgreSQL Server. Changing this forces a new resource to be created."
  type        = string
  default = "postgresdineshpoc"
}

variable "sku_name" {
  description = "Specifies the SKU Name for this PostgreSQL Server. The name of the SKU, follows the tier + family + cores pattern (e.g. B_Gen4_1, GP_Gen5_8)."
  type        = string
  default     = "GP_Gen5_4"
}

variable "administrator_login" {
  description = "The Administrator Login for the PostgreSQL Server. Changing this forces a new resource to be created."
  type        = string
  default = "login"
}

variable "administrator_password" {
  description = "The Password associated with the administrator_login for the PostgreSQL Server."
  type        = string
  default = "Pb:J,Wc]#;4W)rac"
}

variable "public_network_access_enabled" {
  description = "Whether or not public network access is allowed for this server. Possible values are Enabled and Disabled."
  type        = bool
  default     = true
}

variable "db_names" {
  description = "The list of names of the PostgreSQL Database, which needs to be a valid PostgreSQL identifier. Changing this forces a new resource to be created."
  type        = list(string)
  default     = ["capturedb"]
}

variable "postgres_vnet_rule_name_prefix" {
  description = "Specifies prefix for vnet rule names."
  type        = string  
  default     = "postgresql-vnet-rule-"
}

variable "storage_account_name" {
  description = "Name of the storage account and bucket"
  type        = string
  default     = "storagedineshpoc"
}

variable "sa_container_name" {
  description = "Name of the storage account and bucket"
  type        = string
  default     = "poc"
}

variable "tf_admin_users" {
  description = "Name of the users and groups which need acces on KeyVault"
  type        = set(string)
  default     = ["aksusermsi","DINESH SPN"]
}

variable "aks_user_assigned_identity" {
  description = "Name of the users and groups which need acces on KeyVault"
  type        = string
  default     = "aksusermsi"
}

variable "keyvault_name" {
  description = "Name of the Key Vault to ceate key to encrypt/decrypt"
  type        = string
  default     = "aksvaultpoc"
}

variable "acr_name" {
  description = "Name of the Azure Container Registry"
  type        = string
  default     = "dineshacrpoc"
}
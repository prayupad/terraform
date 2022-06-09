variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "aks_cluster_name" {
  type = string
}


variable "nodepool_node_count" {
  description = "Default nodepool nodes count"
  default     = 1
}

variable "nodepool_vm_size" {
  type = string
  default     = "Standard_D4s_v3"
}

variable "aks_subnet_id" {
  type    = string
} 

variable "docker_bridge_cidr" {
  description = "CNI Docker bridge cidr"
  default     = "172.10.0.1/24"
}

variable "dns_service_ip" {
  description = "CNI DNS service IP"
  default     = "10.0.0.10"
}

variable "k8s_service_cidr" {
  description = "CNI service cidr"
  default     = "10.0.0.0/16"
}

variable "log_analytics_workspace" {
  type = string
}

variable "acr_id" {
  type = string
}

variable "vnet_id" {
  type = string
}
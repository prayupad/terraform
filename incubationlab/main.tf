terraform {

  required_providers {
    azurerm = {
      version = "~>3.8.0"
      source = "hashicorp/azurerm"
    }
  }
  backend "azurerm" {

  }
}

provider "azurerm" {
  features {}
}
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

#resource "azurerm_user_assigned_identity" "aksusermsi" {
 # name                = var.aks_user_assigned_identity
  #resource_group_name = var.resource_group_name
  #location            = var.location
  #depends_on          = [azurerm_resource_group.rg]
#}

# Random Generator
resource "random_id" "log_analytics_workspace_name_suffix" {
    byte_length = 8
}

# Azure Container Registry
resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Standard"
  admin_enabled       = true
  depends_on          = [azurerm_resource_group.rg]
}

# Log Analytics
resource "azurerm_log_analytics_workspace" "akslogworkspace" {
  name                = "akslog-${random_id.log_analytics_workspace_name_suffix.dec}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standalone"
  retention_in_days   = 30
  depends_on          = [azurerm_resource_group.rg]
}

# Log Analytics Solution
resource "azurerm_log_analytics_solution" "akslogsolution" {
  solution_name         = "ContainerInsights"
  location              = var.location
  resource_group_name   = var.resource_group_name
  workspace_name        = azurerm_log_analytics_workspace.akslogworkspace.name
  workspace_resource_id = azurerm_log_analytics_workspace.akslogworkspace.id
  depends_on            = [azurerm_resource_group.rg]

  plan {
    publisher = "Microsoft"
    product = "OMSGallery/ContainerInsights"
  }
}
#resource "azurerm_public_ip" "akspip" {
  #name                = "akspipslb"
  #resource_group_name = var.kube_resource_group_name
  #location            = var.location
  #allocation_method   = "Static"
  #sku                 = "Standard"
  #depends_on          = [azurerm_resource_group.rg]

  #tags = {
  #  environment = "POC"
 # }
#}
module "aksnetwork" {
  source              = "./modules/vnet"
  resource_group_name = var.resource_group_name
  location            = var.location
  vnet_name           = var.vnet_name
  address_space       = ["10.0.0.0/16"]
  depends_on          = [azurerm_resource_group.rg]
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                    = var.aks_clustername
  location                = var.location
  resource_group_name     = var.resource_group_name
  dns_prefix              = var.aks_clustername
  depends_on              = [azurerm_resource_group.rg]


  default_node_pool {
    name                    = "agentpool"
    node_count              = null
    vm_size                 = var.nodepool_vm_size
    #vnet_subnet_id          = module.aksnetwork.akssubnet.subnet_id
    enable_auto_scaling     = var.enable_auto_scaling
    type                    = "VirtualMachineScaleSets"
    os_disk_size_gb         = 30
    max_pods                = 110
    max_count               = 5
    min_count               = 1
  }

  identity {
    type = "SystemAssigned"
    #user_assigned_identity_id = azurerm_user_assigned_identity.aksusermsi.id
  }

  network_profile {
    docker_bridge_cidr = var.network_docker_bridge_cidr
    dns_service_ip     = var.network_dns_service_ip
    network_plugin     = "azure"    
    service_cidr       = var.network_service_cidr
    #load_balancer_sku = "Standard"
  }
}
  #addon_profile {
   # oms_agent {
    #  enabled = true
     # log_analytics_workspace_id = azurerm_log_analytics_workspace.akslogworkspace.id
    #}
  #}


# ACR role
resource "azurerm_role_assignment" "aks_to_acr_role" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  skip_service_principal_aad_check = true
}


  


terraform {
  required_version = ">= 0.12"
  }

provider "azurerm" {
  version = "~>2.5" //outbound_type https://github.com/terraform-providers/terraform-provider-azurerm/blob/v2.5.0/CHANGELOG.md
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.kube_resource_group_name
  location = var.location
}

resource "azurerm_user_assigned_identity" "aksusermsi" {
  name                = var.aks_user_assigned_identity
  resource_group_name = var.kube_resource_group_name
  location            = var.location
  depends_on          = [azurerm_resource_group.rg]
}

# Random Generator
resource "random_id" "log_analytics_workspace_name_suffix" {
    byte_length = 8
}

# Azure Container Registry
resource "azurerm_container_registry" "aksacr" {
  name                = var.acr_name
  resource_group_name = var.kube_resource_group_name
  location            = var.location
  sku                 = "Premium"
  admin_enabled       = true
  depends_on          = [azurerm_resource_group.rg]
}

# Log Analytics
resource "azurerm_log_analytics_workspace" "aksoms" {
  name                = "aksoms-${random_id.log_analytics_workspace_name_suffix.dec}"
  location            = var.location
  resource_group_name = var.kube_resource_group_name
  sku                 = "Standalone"
  retention_in_days   = 90
  depends_on          = [azurerm_resource_group.rg]
}

# Log Analytics Solution
resource "azurerm_log_analytics_solution" "aksomssolution" {
  solution_name         = "ContainerInsights"
  location              = var.location
  resource_group_name   = var.kube_resource_group_name
  workspace_name        = azurerm_log_analytics_workspace.aksoms.name
  workspace_resource_id = azurerm_log_analytics_workspace.aksoms.id
  depends_on            = [azurerm_resource_group.rg]

  plan {
    publisher = "Microsoft"
    product = "OMSGallery/ContainerInsights"
  }
}
resource "azurerm_public_ip" "akspip" {
  name                = "akspipslb"
  resource_group_name = var.kube_resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  depends_on          = [azurerm_resource_group.rg]

  tags = {
    environment = "POC"
  }
}
module "kube_network" {
  source              = "./modules/vnet"
  resource_group_name = var.kube_resource_group_name
  location            = var.location
  vnet_name           = var.kube_vnet_name
  address_space       = [var.address_space]
  depends_on          = [azurerm_resource_group.rg]
  subnets = [
    {
      name : var.aks_subnet_name
      address_prefixes : [var.aks_subnet_address_space]
    },
    {
      name : var.private_endpoint_subnet_name
      address_prefixes : [var.private_endpoint_address_space]
    }
  ]
}

resource "azurerm_kubernetes_cluster" "publicaks" {
  name                    = var.aks_cluster_name
  location                = var.location
  node_resource_group     = "MC_${var.kube_resource_group_name}"
  resource_group_name     = var.kube_resource_group_name
  dns_prefix              = var.aks_cluster_name
  depends_on              = [azurerm_resource_group.rg]
  

  dynamic "default_node_pool" {
    for_each = var.enable_auto_scaling == true ? ["default_node_pool_auto_scaled"] : []
    content {
    name                    = "default"
    node_count              = null
    vm_size                 = var.nodepool_vm_size
    vnet_subnet_id          = module.kube_network.subnet_ids["aks-nodes-subnet"]
    enable_auto_scaling     = var.enable_auto_scaling
    type                    = "VirtualMachineScaleSets"
    os_disk_size_gb         = 60
    max_pods                = 110
    max_count               = 100
    min_count               = 1
     }
  }

lifecycle {
      ignore_changes = [
      default_node_pool[0].node_count,
    ]
  }
role_based_access_control {
  enabled = true
   azure_active_directory {
    managed = true
     admin_group_object_ids = ["fbe2c689-eaaf-4647-9e0c-7a9d37ca2b9a"]
   }

  }
     identity {
    type = "UserAssigned"
    user_assigned_identity_id = azurerm_user_assigned_identity.aksusermsi.id
  }
  network_profile {
    docker_bridge_cidr = var.network_docker_bridge_cidr
    dns_service_ip     = var.network_dns_service_ip
    network_plugin     = "azure"    
    service_cidr       = var.network_service_cidr
    load_balancer_sku = "Standard"
   load_balancer_profile {
            outbound_ip_address_ids = [resource.azurerm_public_ip.akspip.id]
        }    
  }
    addon_profile {
    oms_agent {
      enabled = true
      log_analytics_workspace_id = azurerm_log_analytics_workspace.aksoms.id
    }    
  }
}

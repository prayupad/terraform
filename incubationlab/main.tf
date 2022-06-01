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
    subscription_id      = "14c83b29-a1c0-4f29-b32c-9b94ba49886f"
    tenant_id            = "b41b72d0-4e9f-4c26-8a69-f949f367c91d"
}


#Create Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags = {
    environment = "dev"
  }
}

/*
resource "azurerm_user_assigned_identity" "aksusermsi" {
  name                = var.aks_user_assigned_identity
  resource_group_name = var.resource_group_name
  location            = var.location
  depends_on          = [azurerm_resource_group.rg]
} */


#Create Vnet and subnet
module "vnet" {
  source              = "./modules/vnet"
  resource_group_name = var.resource_group_name
  location            = var.location
  vnet_name           = "plabvnet"
  nsg_name            = "pulabnsg"
  #depends_on          = [azurerm_resource_group.rg]
}

# Azure Container Registry
module "acr" {
  source = "./modules/acr"
  resource_group_name = var.resource_group_name
  location = var.location
  acr_name = "plabacr"
  
}

#kubernetes cluster
module "aks" {
  source = "./modules/aks"
  resource_group_name = var.resource_group_name
  location = var.location
  acr_id = module.acr.acr_id
  aks_cluster_name = "plabaks"
  aks_subnet_id = module.vnet.subnetout_id
  log_analytics_workspace = azurerm_log_analytics_workspace.akslogworkspace.id

}

/*
#key vault
module "KeyVault" {
  source = "./modules/KeyVault"
  resource_group_name = var.resource_group_name
  location = var.location
  keyvault_name = "pkeyvault"
}
*/

# Log Analytics
resource "azurerm_log_analytics_workspace" "akslogworkspace" {
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standalone"
  retention_in_days   = 30
  name = var.log_analytics_workspace
}







  


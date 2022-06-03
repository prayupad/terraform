terraform {

  required_providers {
    azurerm = {
      version = "~>3.8.0"
      source = "hashicorp/azurerm"
    }
    azuread = {
      source = "hashicorp/azuread"
      version = "~>2.15.0"
    }
  }
}
/*
  backend "azurerm" {

  }
*/

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
    /*subscription_id      = "14c83b29-a1c0-4f29-b32c-9b94ba49886f"
    tenant_id            = "b41b72d0-4e9f-4c26-8a69-f949f367c91d" */
}

provider "azuread" {
  tenant_id = "b41b72d0-4e9f-4c26-8a69-f949f367c91d"
  
}



#Create Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags = {
    environment = "dev"
  }
}



# Azure Container Registry
module "acr" {
  source = "./modules/acr"
  resource_group_name = azurerm_resource_group.rg.name
  location = var.location
  acr_name = "labacrpu"
  
}

#kubernetes cluster
module "aks" {
  source = "./modules/aks"
  resource_group_name = azurerm_resource_group.rg.name
  location = var.location
  acr_id = module.acr.acr_id
  aks_cluster_name = "labakspu"
  aks_subnet_id = module.vnet.subnetout_id
  log_analytics_workspace = module.loganalytics.law_id

}

# Log Analytics
module "loganalytics" {
  source = "./modules/loganalytics"
  resource_group_name = azurerm_resource_group.rg.name
  location = var.location
  log_analytics = "logworkspacepu"
  
}

#key vault
module "KeyVault" {
  source = "./modules/KeyVault"
  resource_group_name = azurerm_resource_group.rg.name
  location = var.location
  keyvault_name = "keyvaultpu"


}

/*
resource "azurerm_key_vault_key" "key" {
  name         = var.key
  value        = var.secret
  key_vault_id = var.out_keyvault_id
  depends_on = [module.KeyVault]
}
*/

#Create Vnet and subnet
module "vnet" {
  source              = "./modules/vnet"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  vnet_name           = "plabvnet"
  nsg_name            = "plabnsg"
}



/*
resource "azurerm_user_assigned_identity" "aksusermsi" {
  name                = var.aks_user_assigned_identity
  resource_group_name = var.resource_group_name
  location            = var.location
  depends_on          = [azurerm_resource_group.rg]
} */





  


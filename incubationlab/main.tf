terraform {

  required_providers {
    azurerm = {
      version = "~>3.8.0"
      source = "hashicorp/azurerm"
    }


    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~>2.11.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~>2.5.1"
    }
    
  }


  backend "azurerm" {

  }

}
provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}


provider "kubernetes" {
}



provider "helm" {
  kubernetes {
    host = module.aks.host
    client_certificate = base64decode(module.aks.client_certificate)
    client_key = base64decode(module.aks.client_key)
    cluster_ca_certificate = base64decode(module.aks.cluster_ca_certificate)
  }
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
  vnet_id = module.vnet.vnet_id
  aks_cluster_name = "labakspu"
  aks_subnet_id = module.vnet.subnetout_id
  log_analytics_workspace = module.loganalytics.law_id
  depends_on = [module.loganalytics]

}

# Log Analytics
module "loganalytics" {
  source = "./modules/loganalytics"
  resource_group_name = azurerm_resource_group.rg.name
  location = var.location
  log_analytics = "logworkspacepu"
  
}



#Create Vnet and subnet
module "vnet" {
  source              = "./modules/vnet"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  vnet_name           = "labvnetpu"
  nsg_name            = "labnsgpu"
}











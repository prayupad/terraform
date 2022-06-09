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

provider "azuread" {
  tenant_id = "b41b72d0-4e9f-4c26-8a69-f949f367c91d"
  
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
  vnet_name           = "labvnetpu"
  nsg_name            = "labnsgpu"
}



/*
resource "azurerm_user_assigned_identity" "aksusermsi" {
  name                = var.aks_user_assigned_identity
  resource_group_name = var.resource_group_name
  location            = var.location
  depends_on          = [azurerm_resource_group.rg]
} */



#Install Nginx ingress controller using helm charts


resource "helm_release" "nginx" {
  depends_on = [module.aks]
  name             = "nginx-ingress"
  namespace        = "ingress-basic"
  create_namespace = true
  repository       = "https://kubernetes.github.io/ingress-nginx/"
  chart            = "ingress-nginx"

  set {
  name  = "controller.replicaCount"
  value = "2"
  }

  set {
  name  = "controller.nodeSelector\\.beta\\.kubernetes\\.io/os"
  value = "linux"
  }

  set {
  name  = "defaultBackend.nodeSelector\\.beta\\.kubernetes\\.io/os"
  value = "linux"
  }

  set {
  name  = "controller.service.externalTrafficPolicy"
  value = "Local"
  }

  set {
  name  = "controller.service.loadBalancerIP"
  value = "module.aks.public_ip_address"
  }
}

  


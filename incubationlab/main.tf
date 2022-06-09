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

provider "kubernetes" {
    host = module.aks.host
    client_certificate = base64decode(module.aks.client_certificate)
    client_key = base64decode(module.aks.client_key)
    cluster_ca_certificate = base64decode(module.aks.cluster_ca_certificate)

}



provider "helm" {
  kubernetes {
    host = module.aks.host
    client_certificate = base64decode(module.aks.client_certificate)
    client_key = base64decode(module.aks.client_key)
    cluster_ca_certificate = base64decode(module.aks.cluster_ca_certificate)
  }
}

#data "azurerm_client_config" "current" {
#}


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






#Install Nginx ingress controller using helm charts

data "azurerm_public_ip" "kubernetes" {
  name = "lab-akspublicip"
  resource_group_name = "MC_labrgpu_labakspu_eastus"
  depends_on = [module.aks]
}

resource "helm_release" "nginx" {
  
  name             = "ingress-nginx"
  namespace        = "ingress-basic"
  create_namespace = true
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  version          = "4.0.6"
  depends_on = [module.aks]


  set {
  name  = "controller.replicaCount"
  value = "2"
  }

  set {
  name  = "controller.nodeSelector.beta\\.kubernetes\\.io/os"
  value = "linux"
  }

  set {
  name  = "defaultBackend.nodeSelector.beta\\.kubernetes\\.io/os"
  value = "linux"
  }

  set {
  name  = "controller.service.externalTrafficPolicy"
  value = "Local"
  }

  set {
  name  = "controller.service.loadBalancerIP"
  #value = "52.249.198.175"
  value = "module.aks.public_ip_address"
  }

}









##################################
/*
## Creating Kubernetes service and ingress
resource "kubernetes_service" "service" {
  metadata {
    name = "phaseoneapp-service"
  }
  spec {
    port {
      port        = 80
      target_port = 80
      #protocol    = "TCP"
    }
    type = "LoadBalancer"
  }
}

resource "kubernetes_ingress" "ingress" {
  wait_for_load_balancer = true
  metadata {
    name = "phaseoneapp-ingress"
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
    }
  }
  spec {
    rule {
      http {
        path {
          path = "/*"
          backend {
            service_name = kubernetes_service.service.metadata.0.name
            service_port = 80
          }
        }
      }
    }
  }
}
*/


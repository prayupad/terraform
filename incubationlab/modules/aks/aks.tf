resource "azurerm_kubernetes_cluster" "aks" {
  name                    = var.aks_cluster_name
  location                = var.location
  resource_group_name     = var.resource_group_name
  dns_prefix              = var.aks_cluster_name
  role_based_access_control_enabled = true

identity {
    type = "SystemAssigned"

}

  default_node_pool {
    name                    = "nodepool01"
    node_count              = var.nodepool_node_count
    vm_size                 = var.nodepool_vm_size
    vnet_subnet_id          = var.aks_subnet_id
    #enable_auto_scaling     = true
    type                    = "VirtualMachineScaleSets"
    os_disk_size_gb         = 30
    #max_pods                = 
    #max_count               = 
    #min_count               = 
  }



  network_profile {
    docker_bridge_cidr = var.docker_bridge_cidr
    dns_service_ip     = var.dns_service_ip
    network_plugin     = "azure"    
    service_cidr       = var.k8s_service_cidr
    load_balancer_sku = "standard"
  }


oms_agent {
      log_analytics_workspace_id = var.log_analytics_workspace
}
}

#ACR Role assignment
resource "azurerm_role_assignment" "role_acrpull" {
  scope                            = var.acr_id
  role_definition_name             = "AcrPull"
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  skip_service_principal_aad_check = true
}



resource "azurerm_public_ip" "kubernetes" {
  name = "lab-akspublicip"
  location = var.location
  resource_group_name  = "${azurerm_kubernetes_cluster.aks.node_resource_group}"
  allocation_method = "Static"
  sku = "Standard"

}

/*
resource "azurerm_role_assignment" "role_network" {
  scope                            = var.vnet_id
  role_definition_name             = "Network Contributor"
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  skip_service_principal_aad_check = true
}
*/



#Install Nginx ingress controller using helm charts


resource "helm_release" "nginx" {
  
  name             = "ingress-nginx"
  namespace        = "ingress-basic"
  create_namespace = true
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  version          = "4.0.6"
  depends_on = [azurerm_kubernetes_cluster.aks , azurerm_public_ip.kubernetes]


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
  value = "20.121.29.161"
  #value = "azurerm_public_ip.kubernetes.ip_address"
  }

}
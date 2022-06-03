resource "azurerm_kubernetes_cluster" "aks" {
  name                    = var.aks_cluster_name
  location                = var.location
  resource_group_name     = var.resource_group_name
  dns_prefix              = var.aks_cluster_name
  role_based_access_control_enabled = true

identity {
    type = "SystemAssigned"
    #user_assigned_identity_id = azurerm_user_assigned_identity.aksusermsi.id
}

  default_node_pool {
    name                    = "nodepool01"
    node_count              = 2
    vm_size                 = var.nodepool_vm_size
    vnet_subnet_id          = var.aks_subnet_id
    #enable_auto_scaling     = true
    type                    = "VirtualMachineScaleSets"
    os_disk_size_gb         = 30
    #max_pods                = 110
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
  #skip_service_principal_aad_check = true
}


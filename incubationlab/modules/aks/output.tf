

output "host" {
  value = azurerm_kubernetes_cluster.aks.kube_config.0.host
}

output "client_key" {
  value = azurerm_kubernetes_cluster.aks.kube_config.0.client_key
  sensitive = true
}

output "client_certificate" {
  value = azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate
  sensitive = true
}

output "cluster_ca_certificate" {
  value = azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate
  sensitive = true
}

/*
output "public_ip_address" {
  value = azurerm_public_ip.kubernetes.ip_address
  
}
*/



output "kube_config" {
  value = azurerm_kubernetes_cluster.aks.kube_config_raw
}
/* output "kube_config" {
    value = "${azurerm_kubernetes_cluster.aks.kube_config_raw}"
    sensitive = true
} */

output "subnetout_id" {
    value = azurerm_log_analytics_workspace.akslogworkspace.id
}

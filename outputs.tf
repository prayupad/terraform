# output "ssh_command" {
#   value = "ssh ${module.jumpbox.jumpbox_username}@${module.jumpbox.jumpbox_ip}"
#   sensitive = true
# }

output "kube_config" {
    value = "${azurerm_kubernetes_cluster.publicaks.kube_config_raw}"
    sensitive = true
}
# output "jumpbox_password" {
#   description = "Jumpbox Admin Passowrd"
#   value       = module.jumpbox.jumpbox_password
# }
output "public_ip_address" {
    value = azurerm_public_ip.kubernetes.ip_address
}
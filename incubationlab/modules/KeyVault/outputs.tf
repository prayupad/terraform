
#output "out_keyvault_id" {
 # value       = azurerm_key_vault.vault.id
#}


output "objectoutid" {
  value = azurerm_client_config.current.object_id
}

output "tenantoutid" {
  value = azurerm_client_config.current.tenant_id
}
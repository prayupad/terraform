
output "key_vault_key_id" {
  description = "ID for the Key Vault key used to encrypt Terraform secrets"
  value       = azurerm_key_vault_key.key.id
}

output "user_identity" {
  description = "Details about the user assigned identity that can access the storage account"
  value = {
    id : azurerm_user_assigned_identity.identity.id
    client_id : azurerm_user_assigned_identity.identity.client_id
  }
}

output "container_url" {
  description = "URL for accessing the bucket"
  value       = azurerm_storage_container.container.id
}

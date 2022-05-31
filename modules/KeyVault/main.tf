
resource "azurerm_key_vault" "vault" {
  name                = var.keyvault_name
  resource_group_name = var.kube_resource_group_name
  location            = var.location
  sku_name            = "standard"
  tenant_id           = data.azurerm_client_config.current.tenant_id
  #soft_delete_retention_days = 30

}

# resource "azurerm_key_vault_access_policy" "access" {
#   key_vault_id = azurerm_key_vault.vault.id
#   object_id    = each.value.object_id
#   tenant_id    = data.azurerm_client_config.current.tenant_id

#   # Protect from accidentally deleting the key by only allowing deletion during tests
#   # If you really want to delete the key, then manually add the permissions first
#   key_permissions = concat([
#     "Encrypt",
#     "Decrypt",
#     "Get",
#     "Create",
#     "List",
#   ])
#   secret_permissions      = []
#   storage_permissions     = []
#   certificate_permissions = []

#   # It seems like it should be possible to grant access to an entire group rather than just users, but it didn't work for me
#   for_each = data.azuread_user.tf_admins
# }

resource "azurerm_key_vault_key" "key" {
  name         = "key"
  key_vault_id = azurerm_key_vault.vault.id
  key_type     = "RSA"
  key_size     = 4096

  key_opts = [
    "decrypt",
    "encrypt",
  ]

  #depends_on = [azurerm_key_vault_access_policy.access]
}

data "azuread_client_config" "current" {}

data "azurerm_client_config" "current" {}

# data "azuread_user" "tf_admins" {
#   user_principal_name = each.value

#   for_each = var.tf_admin_users
# }
resource "azurerm_storage_account" "account" {
  account_replication_type = "ZRS"
  account_tier             = "Standard"
  name                     = var.name

  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

resource "azurerm_storage_container" "container" {
  name                  = "${var.name}-bucket"
  storage_account_name  = azurerm_storage_account.account.name
  container_access_type = "private"
}

resource "azurerm_user_assigned_identity" "identity" {
  name = "${var.name}-key"

  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

resource "azurerm_role_assignment" "storage_role" {
  scope                = azurerm_storage_account.account.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.identity.principal_id
}

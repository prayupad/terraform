data "azurerm_client_config" "current" {}


resource "azurerm_key_vault" "vault" {
  name                = var.keyvault_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku_name            = "standard"
  tenant_id           = data.azurerm_client_config.current.tenant_id
 

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get", "List", "Set", "Delete"
    ]

    secret_permissions = [
      "Get", "List", "Set", "Delete"
    ]

    storage_permissions = [
      "Get", "List"
    ]
  } 

}




resource "azurerm_network_security_group" "nsg" {
  name                = "aks-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
}


resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = var.address_space
  location            = var.location
  resource_group_name = var.resource_group_name
}
resource "azurerm_subnet" "akssubnet" {
  name                = var.subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = "10.0.1.0/24"
  #security_group = azurerm_network_security_group.nsg.id
}



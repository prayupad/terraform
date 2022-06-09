resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg_name
  location            = var.location
  resource_group_name = var.resource_group_name
}


resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = var.vnet_address_range
  location            = var.location
  resource_group_name = var.resource_group_name
}
resource "azurerm_subnet" "akssubnet" {
  name                 = var.aks_subnet
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.akssubnet_address_range

}


resource "azurerm_subnet_network_security_group_association" "nsg_as" {
  subnet_id                 = azurerm_subnet.akssubnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

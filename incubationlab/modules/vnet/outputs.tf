#output vnet_id {
 # description = "Generated VNET ID"
  #value       = azurerm_virtual_network.vnet.id
#}

output subnetout_id {
  value= azurerm_subnet.akssubnet.id
}



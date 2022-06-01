#output vnet_id {
 # description = "Generated VNET ID"
  #value       = azurerm_virtual_network.vnet.id
#}

output subnetout_id {
  value= azurerm_subnet.akssubnet.id
}

#output "vnet_subnets" {
 # description = "The ids of subnets created inside the newly created vNet"
  #value       = [ for subnet in azurerm_subnet.subnet : subnet.id ]
#}


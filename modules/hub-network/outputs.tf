output "firewall_subnet_id" {
  value = azurerm_subnet.AzureFirewallSubnet.id
}
output "bastion_subnet_id" {
  value = azurerm_subnet.AzureBastionSubnet.id
}
output "vnet_id" {
  value = azurerm_virtual_network.project-vnet.id
}
output "vnet_name" {
  value = azurerm_virtual_network.project-vnet.name
}
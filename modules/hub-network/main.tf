resource "azurerm_virtual_network" "project-vnet" {
  name                = var.vnet_name
  address_space       = var.vnet_address_space
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "AzureFirewallSubnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.project-vnet.name
  address_prefixes     = [var.firewall_subnet_prefix]
}

resource "azurerm_subnet" "AzureBastionSubnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.project-vnet.name
  address_prefixes     = [var.bastion_subnet_prefix]
}

resource "azurerm_subnet" "GatewaySubnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.project-vnet.name
  address_prefixes     = [var.gateway_subnet_prefix]
}

resource "azurerm_subnet" "managementSubnet" {
  name                 = "managementSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.project-vnet.name
  address_prefixes     = [var.management_subnet_prefix]
}
resource "azurerm_resource_group" "hub" {
  name     = "rg-hub-dev"
  location = var.location
}

module "hub_network" {
  source              = "../../modules/hub-network"
  resource_group_name = azurerm_resource_group.hub.name
  location            = azurerm_resource_group.hub.location
}

module "firewall" {
  source                   = "../../modules/firewall"
  resource_group_name      = azurerm_resource_group.hub.name
  location                 = azurerm_resource_group.hub.location
  firewall_subnet_id       = module.hub_network.firewall_subnet_id
  allowed_source_addresses = ["10.0.0.0/8"]
}

module "bastion" {
  source              = "../../modules/bastion"
  resource_group_name = azurerm_resource_group.hub.name
  location            = azurerm_resource_group.hub.location
  bastion_subnet_id   = module.hub_network.bastion_subnet_id
}

module "dns_zones" {
  source              = "../../modules/dns-zones"
  resource_group_name = azurerm_resource_group.hub.name
  virtual_network_id  = module.hub_network.vnet_id
}

module "monitoring" {
  source              = "../../modules/monitoring"
  resource_group_name = azurerm_resource_group.hub.name
  location            = azurerm_resource_group.hub.location
}

resource "azurerm_resource_group" "spoke1" {
  name     = "rg-spoke1-network-eastus-001"
  location = var.location
}

resource "azurerm_resource_group" "spoke2" {
  name     = "rg-spoke2-network-eastus-001"
  location = var.location
}

module "spoke1_network" {
  source                  = "../../modules/spoke-network"
  resource_group_name     = azurerm_resource_group.spoke1.name
  location                = var.location
  vnet_name               = "vnet-spoke1-eastus-001"
  vnet_address_space      = ["10.1.0.0/16"]
  app_subnet_prefix       = "10.1.1.0/24"
  data_subnet_prefix      = "10.1.2.0/24"
  pe_subnet_prefix        = "10.1.3.0/24"
  firewall_private_ip     = module.firewall.firewall_private_ip
  hub_vnet_name           = module.hub_network.vnet_name
  hub_vnet_id             = module.hub_network.vnet_id
  hub_resource_group_name = azurerm_resource_group.hub.name
}

module "spoke2_network" {
  source                  = "../../modules/spoke-network"
  resource_group_name     = azurerm_resource_group.spoke2.name
  location                = var.location
  vnet_name               = "vnet-spoke2-eastus-001"
  vnet_address_space      = ["10.2.0.0/16"]
  app_subnet_prefix       = "10.2.1.0/24"
  data_subnet_prefix      = "10.2.2.0/24"
  pe_subnet_prefix        = "10.2.3.0/24"
  firewall_private_ip     = module.firewall.firewall_private_ip
  hub_vnet_name           = module.hub_network.vnet_name
  hub_vnet_id             = module.hub_network.vnet_id
  hub_resource_group_name = azurerm_resource_group.hub.name
}

module "policies" {
  source = "../../modules/policies"
  allowed_locations = ["eastus", "eastus2", "global"]
  required_tags     = ["Environment", "Owner", "CostCenter", "ManagedBy"]
}
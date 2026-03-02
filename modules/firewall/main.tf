resource "azurerm_public_ip" "public_ip" {
  name                = "fw-public-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall_policy" "firewall_policy" {
  name                = "firewall-policy"
  resource_group_name = var.resource_group_name
  location            = var.location
}

resource "azurerm_firewall" "AZFW_VNet" {
  name                = "AZFW-VNet"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"
  firewall_policy_id  = azurerm_firewall_policy.firewall_policy.id

  ip_configuration {
    name                 = "configuration"
    subnet_id            = var.firewall_subnet_id
    public_ip_address_id = azurerm_public_ip.public_ip.id
  }
}

resource "azurerm_firewall_policy_rule_collection_group" "default" {
  name               = "default-rule-collection-group"
  firewall_policy_id = azurerm_firewall_policy.firewall_policy.id
  priority           = 300

  network_rule_collection {
    name     = "allow-dns-https"
    priority = 400
    action   = "Allow"
    rule {
      name                  = "allow-dns-https"
      protocols             = ["TCP", "UDP"]
      source_addresses      = var.allowed_source_addresses
      destination_addresses = ["*"]
      destination_ports     = ["53", "443"]
    }
  }
}
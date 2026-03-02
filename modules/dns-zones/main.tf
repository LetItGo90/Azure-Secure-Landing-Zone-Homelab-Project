resource "azurerm_private_dns_zone" "dns" {
  for_each            = toset(var.private_dns_zones)
  name                = each.value
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "dns_link" {
  for_each              = toset(var.private_dns_zones)
  name                  = "${replace(each.value, ".", "-")}-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.dns[each.key].name
  virtual_network_id    = var.virtual_network_id
}
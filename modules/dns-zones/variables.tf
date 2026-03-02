variable "resource_group_name" {
  type = string
}

variable "private_dns_zones" {
  type = list(string)
  default = [
    "privatelink.database.windows.net",
    "privatelink.vaultcore.azure.net",
    "privatelink.azurewebsites.net"
  ]
}

variable "virtual_network_id" {
  type = string
}
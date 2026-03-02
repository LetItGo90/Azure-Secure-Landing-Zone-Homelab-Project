variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "vnet_name" {
  type = string
}

variable "vnet_address_space" {
  type = list(string)
}

variable "app_subnet_prefix" {
  type = string
}

variable "data_subnet_prefix" {
  type = string
}

variable "pe_subnet_prefix" {
  type = string
}

variable "firewall_private_ip" {
  type = string
}

variable "hub_vnet_name" {
  type = string
}

variable "hub_vnet_id" {
  type = string
}

variable "hub_resource_group_name" {
  type = string
}
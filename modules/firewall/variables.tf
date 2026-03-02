variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "firewall_subnet_id" {
  type = string
}

variable "allowed_source_addresses" {
  type    = list(string)
  default = ["10.0.0.0/16"]
}
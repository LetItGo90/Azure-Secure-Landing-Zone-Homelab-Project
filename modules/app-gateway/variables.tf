variable "GatewaySubnet_prefix" {
  description = "CIDR range for the Azure Gateway subnet"
  type        = string
  default     = "10.0.4.0/24"
}
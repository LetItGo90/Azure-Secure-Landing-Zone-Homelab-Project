variable "allowed_locations" {
  type        = list(string)
  description = "List of allowed Azure regions"
  default     = ["eastus", "eastus2", "global"]
}

variable "required_tags" {
  type        = list(string)
  description = "List of required tag names"
  default     = ["Environment", "Owner", "CostCenter", "ManagedBy"]
}
locals {
  location = "eastus"
  
  default_tags = {
    Environment = "dev"
    Owner       = "austin"
    CostCenter  = "learning"
    ManagedBy   = "terraform"
    Project     = "azure-secure-landing-zone"
  }
}
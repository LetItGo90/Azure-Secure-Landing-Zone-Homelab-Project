terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state-eastus-001"
    storage_account_name = "storageproject01"
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"
  }
}
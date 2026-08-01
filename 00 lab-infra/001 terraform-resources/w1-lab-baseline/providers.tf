provider "azurerm" {
  features {}

  tenant_id       = var.training_tenant_id
  subscription_id = var.training_subscription_id
}
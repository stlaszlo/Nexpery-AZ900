resource "azurerm_resource_group" "test" {
  name     = "rsg-terraform-test"
  location = "Germany West Central"
  tags = {
    purpose     = "terraform-test"
    environment = "sandboxtest"
    managed_by  = "terraform"
    owner       = "Laszlo Stomp"
  }

}
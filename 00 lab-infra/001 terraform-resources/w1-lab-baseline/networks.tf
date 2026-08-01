resource "azurerm_virtual_network" "hub" {
  name                = "vnet-hub"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name
  address_space       = ["10.0.0.0/16"]

  tags = merge(local.common_tags, {
    role = "hub"
  })
}

resource "azurerm_subnet" "hub_shared_services" {
  name                 = "snet-shared-services"
  resource_group_name  = azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_virtual_network" "student" {
  for_each = var.students

  name                = "vnet-${each.key}"
  location            = azurerm_resource_group.student[each.key].location
  resource_group_name = azurerm_resource_group.student[each.key].name
  address_space       = [each.value.vnet_cidr]

  tags = merge(local.common_tags, {
    role         = "student"
    student_code = each.key
    student_name = each.value.display_name
  })
}

resource "azurerm_subnet" "student_workload" {
  for_each = var.students

  name                 = "snet-workload"
  resource_group_name  = azurerm_resource_group.student[each.key].name
  virtual_network_name = azurerm_virtual_network.student[each.key].name
  address_prefixes     = [each.value.workload_subnet]
}

resource "azurerm_subnet" "student_management" {
  for_each = var.students

  name                 = "snet-management"
  resource_group_name  = azurerm_resource_group.student[each.key].name
  virtual_network_name = azurerm_virtual_network.student[each.key].name
  address_prefixes     = [each.value.management_subnet]
}
output "hub" {
  description = "Hub resource and network information"

  value = {
    resource_group = azurerm_resource_group.hub.name
    vnet_name      = azurerm_virtual_network.hub.name
    vnet_id        = azurerm_virtual_network.hub.id
    address_space  = azurerm_virtual_network.hub.address_space
  }
}

output "student_environments" {
  description = "Created student resource groups and virtual networks"

  value = {
    for student_code, student in var.students :
    student_code => {
      display_name      = student.display_name
      resource_group    = azurerm_resource_group.student[student_code].name
      vnet_name         = azurerm_virtual_network.student[student_code].name
      vnet_id           = azurerm_virtual_network.student[student_code].id
      vnet_cidr         = student.vnet_cidr
      workload_subnet   = student.workload_subnet
      management_subnet = student.management_subnet
    }
  }
}
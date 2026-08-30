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

output "nva_load_balancer_frontend_ip" {
  description = "Internal Load Balancer frontend IP used as the NVA next hop"
  value       = azurerm_lb.nva.frontend_ip_configuration[0].private_ip_address
}

output "nva_private_ips" {
  description = "Private IP addresses of the NVA instances"
  value = {
    for name, nic in azurerm_network_interface.nva :
    name => nic.private_ip_address
  }
}
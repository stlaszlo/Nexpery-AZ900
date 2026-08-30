resource "azurerm_lb" "nva" {
  name                = "lb-nva-internal"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                          = "nva-frontend"
    subnet_id                     = azurerm_subnet.hub_nva.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.1.4"
  }

  tags = merge(local.common_tags, {
    role = "nva-load-balancer"
  })
}

resource "azurerm_lb_backend_address_pool" "nva" {
  name            = "nva-backend-pool"
  loadbalancer_id = azurerm_lb.nva.id
}

resource "azurerm_network_interface_backend_address_pool_association" "nva" {
  for_each = local.nvas

  network_interface_id    = azurerm_network_interface.nva[each.key].id
  ip_configuration_name   = "ipconfig1"
  backend_address_pool_id = azurerm_lb_backend_address_pool.nva.id
}

resource "azurerm_lb_probe" "nva" {
  name            = "nva-health"
  loadbalancer_id = azurerm_lb.nva.id

  protocol = "Tcp"
  port     = 9000

  interval_in_seconds = 5
  number_of_probes    = 2
}

resource "azurerm_lb_rule" "nva_ha_ports" {
  name            = "nva-ha-ports"
  loadbalancer_id = azurerm_lb.nva.id

  protocol      = "All"
  frontend_port = 0
  backend_port  = 0

  frontend_ip_configuration_name = "nva-frontend"

  backend_address_pool_ids = [
    azurerm_lb_backend_address_pool.nva.id
  ]

  probe_id = azurerm_lb_probe.nva.id

  floating_ip_enabled = false
}
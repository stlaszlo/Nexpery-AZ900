resource "azurerm_network_security_group" "nva" {
  name                = "nsg-nva"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name

  tags = merge(local.common_tags, {
    role = "nva"
  })
}

resource "azurerm_network_security_rule" "nva_health_probe" {
  name                       = "AllowAzureLoadBalancerProbe"
  priority                   = 100
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "9000"
  source_address_prefix      = "AzureLoadBalancer"
  destination_address_prefix = "*"

  resource_group_name         = azurerm_resource_group.hub.name
  network_security_group_name = azurerm_network_security_group.nva.name
}

resource "azurerm_network_security_rule" "nva_vnet_inbound" {
  name                       = "AllowVNetInbound"
  priority                   = 110
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "*"
  source_port_range          = "*"
  destination_port_range     = "*"
  source_address_prefix      = "VirtualNetwork"
  destination_address_prefix = "*"

  resource_group_name         = azurerm_resource_group.hub.name
  network_security_group_name = azurerm_network_security_group.nva.name
}

resource "azurerm_subnet_network_security_group_association" "nva" {
  subnet_id                 = azurerm_subnet.hub_nva.id
  network_security_group_id = azurerm_network_security_group.nva.id
}
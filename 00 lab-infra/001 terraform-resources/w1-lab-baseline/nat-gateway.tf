resource "azurerm_public_ip" "nva_nat" {
  name                = "pip-nva-nat"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name

  allocation_method = "Static"
  sku               = "Standard"

  tags = merge(local.common_tags, {
    role = "nva-outbound"
  })
}

resource "azurerm_nat_gateway" "nva" {
  name                = "natgw-nva"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name

  sku_name                = "Standard"
  idle_timeout_in_minutes = 10

  tags = merge(local.common_tags, {
    role = "nva-outbound"
  })
}

resource "azurerm_nat_gateway_public_ip_association" "nva" {
  nat_gateway_id       = azurerm_nat_gateway.nva.id
  public_ip_address_id = azurerm_public_ip.nva_nat.id
}

resource "azurerm_subnet_nat_gateway_association" "nva" {
  subnet_id      = azurerm_subnet.hub_nva.id
  nat_gateway_id = azurerm_nat_gateway.nva.id
}
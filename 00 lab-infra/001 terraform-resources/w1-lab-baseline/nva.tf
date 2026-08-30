locals {
  nvas = {
    nva01 = {
      private_ip = "10.0.1.5"
    }

    nva02 = {
      private_ip = "10.0.1.6"
    }
  }
}

resource "azurerm_network_interface" "nva" {
  for_each = local.nvas

  name                = "nic-${each.key}"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name

  ip_forwarding_enabled = true

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.hub_nva.id
    private_ip_address_allocation = "Static"
    private_ip_address            = each.value.private_ip
  }

  tags = merge(local.common_tags, {
    role = "nva"
  })
}

resource "azurerm_linux_virtual_machine" "nva" {
  for_each = local.nvas

  name                = each.key
  resource_group_name = azurerm_resource_group.hub.name
  location            = azurerm_resource_group.hub.location
  size                = "Standard_D2als_v7"

  admin_username = var.nva_admin_username

  network_interface_ids = [
    azurerm_network_interface.nva[each.key].id
  ]

  disable_password_authentication = true

  admin_ssh_key {
    username   = var.nva_admin_username
    public_key = file(var.nva_ssh_public_key_path)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }

  custom_data = base64encode(
    templatefile("${path.module}/nva-cloud-init.tftpl", {
      hostname = each.key
    })
  )

  tags = merge(local.common_tags, {
    role = "nva"
  })
}
resource "azurerm_network_interface" "nic" {
  for_each = var.vms

  name                = "${each.value.name}-nic"
  resource_group_name = each.value.resource_group_name
  location             = each.value.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.subnet[each.key].id
    private_ip_address_allocation = "Dynamic"
    # public_ip_name khaali ho (jaise vm3/DB tier) toh public IP attach hi nahi hoga
    public_ip_address_id = each.value.public_ip_name != "" ? data.azurerm_public_ip.public_ip[each.key].id : null
  }

  tags = var.tags
}

resource "azurerm_linux_virtual_machine" "vm" {
  for_each = var.vms

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  size                = each.value.size
  admin_username      = each.value.admin_username
  admin_password      = each.value.admin_password

  # Password-based login use ho raha hai, isliye SSH key authentication disable karo
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.nic[each.key].id
  ]

  os_disk {
    caching              = each.value.caching
    storage_account_type = each.value.storage_account_type
  }

  source_image_reference {
    publisher = each.value.publisher
    offer     = each.value.offer
    sku       = each.value.sku
    version   = each.value.version
  }

  tags = var.tags
}

data "azurerm_public_ip" "public_ip" {
  # sirf un VMs ke liye lookup karo jinka public_ip_name khaali nahi hai
  for_each = { for k, v in var.vms : k => v if v.public_ip_name != "" }

  name                = each.value.public_ip_name
  resource_group_name = each.value.resource_group_name
}

data "azurerm_subnet" "subnet" {
  for_each = var.vms

  name                 = each.value.subnet_name
  resource_group_name  = each.value.resource_group_name
  virtual_network_name = each.value.virtual_network_name
}

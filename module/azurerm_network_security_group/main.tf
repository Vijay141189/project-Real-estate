# Network Security Group banate hain
resource "azurerm_network_security_group" "nsg" {
  for_each = var.nsgs

  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  tags                = var.tags
}

# Har NSG ke andar security rules banate hain (dynamic block, kyunki har tier ke rules alag ho sakte hain)
resource "azurerm_network_security_rule" "rules" {
  for_each = {
    for pair in flatten([
      for nsg_key, nsg in var.nsgs : [
        for rule_key, rule in nsg.rules : {
          key                        = "${nsg_key}-${rule_key}"
          nsg_key                    = nsg_key
          name                       = rule.name
          priority                   = rule.priority
          direction                  = rule.direction
          access                     = rule.access
          protocol                   = rule.protocol
          source_port_range          = rule.source_port_range
          destination_port_range     = rule.destination_port_range
          source_address_prefix      = rule.source_address_prefix
          destination_address_prefix = rule.destination_address_prefix
        }
      ]
    ]) : pair.key => pair
  }

  name                        = each.value.name
  priority                    = each.value.priority
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_range      = each.value.destination_port_range
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  resource_group_name         = var.nsgs[each.value.nsg_key].resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg[each.value.nsg_key].name
}

# NSG ko subnet ke saath associate karte hain
# NOTE: for_each yahan "subnet_association_keys" (static set, root module se pass hota hai) par based hai,
# na ki "subnet_id" (jo subnet create hone ke baad hi pata chalta hai) par —
# warna Terraform plan time pe for_each ke keys resolve nahi kar payega ("Invalid for_each argument" error).
resource "azurerm_subnet_network_security_group_association" "nsg_assoc" {
  for_each = var.subnet_association_keys

  subnet_id                 = var.nsgs[each.value].subnet_id
  network_security_group_id = azurerm_network_security_group.nsg[each.value].id
}

module "azurerm_resource_group" {
  source = "../../module/azurerm_resource_group"
  rgs    = var.rgs
  tags   = var.tags
}

module "azurerm_storage_account" {
  depends_on       = [module.azurerm_resource_group]
  source           = "../../module/azurerm_storage_account"
  storage_accounts = var.storage_accounts
  tags             = var.tags
}

module "azurerm_virtual_network" {
  depends_on = [module.azurerm_resource_group]
  source     = "../../module/azurerm_virtual_network"
  vnets      = var.vnets
  tags       = var.tags
}

module "azurerm_subnet" {
  depends_on = [module.azurerm_virtual_network, module.azurerm_resource_group]
  source     = "../../module/azurerm_subnet"
  subnets    = var.subnets
}

module "azurerm_public_IP" {
  depends_on = [module.azurerm_resource_group]
  source     = "../../module/azurerm_public_IP"
  public_ips = var.public_ips
  tags       = var.tags
}

module "azurerm_key_vault" {
  depends_on = [module.azurerm_resource_group]
  source     = "../../module/azurerm_key_vault"
  key_vaults = var.key_vaults
}

# NSGs ko subnets ke saath wire karte hain — subnet module ke output (subnet_ids) se
# har NSG entry me subnet_id inject kar rahe hain taaki association ban sake
locals {
  nsgs_with_subnet_ids = {
    for k, v in var.nsgs : k => {
      name                = v.name
      location            = v.location
      resource_group_name = v.resource_group_name
      subnet_id           = v.subnet_key != null ? module.azurerm_subnet.subnet_ids[v.subnet_key] : null
      rules               = v.rules
    }
  }
}

# Static set — sirf subnet_key (tfvars se, plan time pe hi known) ke basis par banaya,
# subnet_id (jo apply ke baad pata chalta hai) use nahi kiya, warna for_each error aayega
locals {
  nsg_subnet_association_keys = toset([for k, v in var.nsgs : k if v.subnet_key != null])
}

module "azurerm_network_security_group" {
  depends_on               = [module.azurerm_subnet, module.azurerm_resource_group]
  source                   = "../../module/azurerm_network_security_group"
  nsgs                     = local.nsgs_with_subnet_ids
  subnet_association_keys  = local.nsg_subnet_association_keys
  tags                     = var.tags
}

# vms input me admin_password ko Key Vault se generate hue password se replace kar rahe hain,
# taaki plaintext password kahin tfvars me na rahe
locals {
  vms_with_password = {
    for k, v in var.vms : k => merge(v, {
      admin_password = module.azurerm_key_vault.vm_admin_passwords["key_vault1"]
    })
  }
}

module "azurerm_virtual_machine" {
  depends_on = [module.azurerm_subnet, module.azurerm_public_IP, module.azurerm_resource_group, module.azurerm_key_vault, module.azurerm_network_security_group]
  source     = "../../module/azurerm_virtual_machine"
  vms        = local.vms_with_password
  tags       = var.tags
}

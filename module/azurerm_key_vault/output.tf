output "key_vault_ids" {
  description = "Map of Key Vault IDs"
  value       = { for k, v in azurerm_key_vault.kv : k => v.id }
}

output "vm_admin_passwords" {
  description = "Map of generated VM admin passwords, keyed same as key_vaults"
  value       = { for k, v in azurerm_key_vault_secret.vm_admin_password : k => v.value }
  sensitive   = true
}

output "subnet_ids" {
  description = "Map of subnet key => subnet resource ID, NSG association ke liye use hota hai"
  value       = { for k, v in azurerm_subnet.subnets : k => v.id }
}

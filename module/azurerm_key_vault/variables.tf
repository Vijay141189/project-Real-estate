variable "key_vaults" {
  description = "Map of Azure Key Vaults to create"
  type = map(object({
    name                        = string
    resource_group_name         = string
    location                    = string
    sku_name                    = string
    purge_protection_enabled    = bool
    soft_delete_retention_days  = number
    tenant_id                   = optional(string) # blank chodo toh current subscription ka tenant_id apne aap use hoga
    object_id                   = optional(string) # blank chodo toh terraform chalane wale user/SP ko access milega; specify karo toh us user/group/SP ko access milega
  }))
}
resource "azurerm_storage_account" "example" {
  for_each = var.storage_accounts

  name                     = each.value.name
  resource_group_name      = each.value.resource_group_name
  location                 = each.value.location
  account_tier             = each.value.account_tier
  account_replication_type = each.value.account_replication_type

  # Cloud security policy: internet se direct public access band karo
  public_network_access_enabled = false

  # FinOps policy: last access time tracking on karo, taaki lifecycle rules access-time ke basis pe chal sakein
  blob_properties {
    last_access_time_enabled = true
  }

  tags = var.tags
}

# FinOps policy: purana/cold data automatically cheaper tier me move ho ya delete ho, taaki storage cost control me rahe
resource "azurerm_storage_management_policy" "example" {
  for_each = var.storage_accounts

  storage_account_id = azurerm_storage_account.example[each.key].id

  rule {
    name    = "lifecycle-rule"
    enabled = true

    filters {
      blob_types = ["blockBlob"]
    }

    actions {
      base_blob {
        tier_to_cool_after_days_since_last_access_time_greater_than    = 30
        tier_to_archive_after_days_since_last_access_time_greater_than = 90
        delete_after_days_since_last_access_time_greater_than          = 365
      }
    }
  }
}

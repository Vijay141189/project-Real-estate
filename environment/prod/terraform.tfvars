rgs = {
  rg1 = {
    name     = "resourcegroup1411-prod"
    location = "southeastasia"
  }
}

storage_accounts = {
  sa1 = {
    name                     = "storageblob1411prod" # Storage Account names cannot contain hyphens
    resource_group_name      = "resourcegroup1411-prod"
    location                 = "southeastasia"
    account_tier             = "Standard"
    account_replication_type = "LRS"
  }
}

vnets = {
  vnet1 = {
    name                = "Terraformvnet1-prod"
    address_space       = ["10.0.0.0/16"]
    location            = "southeastasia"
    resource_group_name = "resourcegroup1411-prod"
  }
}

subnets = {
  subnet1 = {
    name                 = "frontendsubnet1-prod"
    resource_group_name  = "resourcegroup1411-prod"
    virtual_network_name = "Terraformvnet1-prod"
    address_prefixes     = ["10.0.1.0/24"]
  }
  subnet2 = {
    name                 = "backendsubnet1-prod"
    resource_group_name  = "resourcegroup1411-prod"
    virtual_network_name = "Terraformvnet1-prod"
    address_prefixes     = ["10.0.2.0/24"]
  }
  subnet3 = {
    name                 = "dbsubnet1-prod"
    resource_group_name  = "resourcegroup1411-prod"
    virtual_network_name = "Terraformvnet1-prod"
    address_prefixes     = ["10.0.3.0/24"]
  }
}

public_ips = {
  public_ip1 = {
    name                = "publicip1-prod"
    resource_group_name = "resourcegroup1411-prod"
    location            = "southeastasia"
    allocation_method   = "Static"
  }
  public_ip2 = {
    name                = "publicip2-prod"
    resource_group_name = "resourcegroup1411-prod"
    location            = "southeastasia"
    allocation_method   = "Static"
  }
}

vms = {
  vm1 = {
    name                 = "vm-1-prod"
    resource_group_name  = "resourcegroup1411-prod"
    location             = "southeastasia"
    size                 = "Standard_B2s"
    admin_username       = "adminuser"
    # admin_password ab yaha nahi likha jaata — Key Vault module isse generate/inject karta hai
    subnet_name          = "frontendsubnet1-prod"
    public_ip_name       = "publicip1-prod"
    virtual_network_name = "Terraformvnet1-prod"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    offer                = "UbuntuServer"
    sku                  = "18.04-LTS"
    version              = "latest"
    publisher            = "Canonical"
  }
  vm2 = {
    name                 = "vm-2-prod"
    resource_group_name  = "resourcegroup1411-prod"
    location             = "southeastasia"
    size                 = "Standard_B2s"
    admin_username       = "adminuser"
    # admin_password ab yaha nahi likha jaata — Key Vault module isse generate/inject karta hai
    subnet_name          = "backendsubnet1-prod"
    public_ip_name       = "publicip2-prod"
    virtual_network_name = "Terraformvnet1-prod"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    offer                = "UbuntuServer"
    sku                  = "18.04-LTS"
    version              = "latest"
    publisher            = "Canonical"
  }
  vm3 = {
    name                 = "vm-3-prod"
    resource_group_name  = "resourcegroup1411-prod"
    location             = "southeastasia"
    size                 = "Standard_B2s"
    admin_username       = "adminuser"
    # admin_password ab yaha nahi likha jaata — Key Vault module isse generate/inject karta hai
    subnet_name          = "dbsubnet1-prod"
    public_ip_name       = ""  # DB tier ko public IP nahi milega (best practice)
    virtual_network_name = "Terraformvnet1-prod"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    offer                = "UbuntuServer"
    sku                  = "18.04-LTS"
    version              = "latest"
    publisher            = "Canonical"
  }
}

key_vaults = {
  key_vault1 = {
    name                        = "keyvault1411-prod"
    resource_group_name        = "resourcegroup1411-prod"
    location                   = "southeastasia"
    sku_name                    = "standard"
    purge_protection_enabled    = true
    soft_delete_retention_days  = 90
  }
}

# IMPORTANT: neeche "<REPLACE_WITH_YOUR_PUBLIC_IP>/32" ko apni actual office/VPN public IP se replace karo before apply.
nsgs = {
  nsg_frontend = {
    name                = "nsg-frontend-prod"
    location            = "southeastasia"
    resource_group_name = "resourcegroup1411-prod"
    subnet_key          = "subnet1"
    rules = {
      allow_ssh = {
        name                        = "Allow-SSH-Admin"
        priority                    = 100
        direction                   = "Inbound"
        access                      = "Allow"
        protocol                    = "Tcp"
        source_port_range           = "*"
        destination_port_range      = "22"
        source_address_prefix       = "<REPLACE_WITH_YOUR_PUBLIC_IP>/32"
        destination_address_prefix  = "*"
      }
      allow_https = {
        name                        = "Allow-HTTPS"
        priority                    = 110
        direction                   = "Inbound"
        access                      = "Allow"
        protocol                    = "Tcp"
        source_port_range           = "*"
        destination_port_range      = "443"
        source_address_prefix       = "Internet"
        destination_address_prefix  = "*"
      }
    }
  }
  nsg_backend = {
    name                = "nsg-backend-prod"
    location            = "southeastasia"
    resource_group_name = "resourcegroup1411-prod"
    subnet_key          = "subnet2"
    rules = {
      allow_from_frontend = {
        name                        = "Allow-App-From-Frontend"
        priority                    = 100
        direction                   = "Inbound"
        access                      = "Allow"
        protocol                    = "Tcp"
        source_port_range           = "*"
        destination_port_range      = "8080"
        source_address_prefix       = "10.0.1.0/24"
        destination_address_prefix  = "*"
      }
    }
  }
  nsg_db = {
    name                = "nsg-db-prod"
    location            = "southeastasia"
    resource_group_name = "resourcegroup1411-prod"
    subnet_key          = "subnet3"
    rules = {
      allow_from_backend = {
        name                        = "Allow-DB-From-Backend"
        priority                    = 100
        direction                   = "Inbound"
        access                      = "Allow"
        protocol                    = "Tcp"
        source_port_range           = "*"
        destination_port_range      = "5432"
        source_address_prefix       = "10.0.2.0/24"
        destination_address_prefix  = "*"
      }
    }
  }
}

tags = {
  Environment = "Prod"
  Project     = "LandingZone"
  Owner       = "Vijay"
  ManagedBy   = "Terraform"
  CostCenter  = "IT-Prod"
}

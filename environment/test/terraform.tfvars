rgs = {
  rg1 = {
    name     = "resourcegroup1411-test"
    location = "southeastasia"
  }
}

storage_accounts = {
  sa1 = {
    name                     = "storageblob1411test"
    resource_group_name      = "resourcegroup1411-test"
    location                 = "southeastasia"
    account_tier             = "Standard"
    account_replication_type = "LRS"
  }
}

vnets = {
  vnet1 = {
    name                = "Terraformvnet1-test"
    address_space       = ["10.0.0.0/16"]
    location            = "southeastasia"
    resource_group_name = "resourcegroup1411-test"
  }
}

subnets = {
  subnet1 = {
    name                 = "frontendsubnet1-test"
    resource_group_name  = "resourcegroup1411-test"
    virtual_network_name = "Terraformvnet1-test"
    address_prefixes     = ["10.0.1.0/24"]
  }
  subnet2 = {
    name                 = "backendsubnet1-test"
    resource_group_name  = "resourcegroup1411-test"
    virtual_network_name = "Terraformvnet1-test"
    address_prefixes     = ["10.0.2.0/24"]
  }
  subnet3 = {
    name                 = "dbsubnet1-test"
    resource_group_name  = "resourcegroup1411-test"
    virtual_network_name = "Terraformvnet1-test"
    address_prefixes     = ["10.0.3.0/24"]
  }
}

public_ips = {
  public_ip1 = {
    name                = "publicip1-test"
    resource_group_name = "resourcegroup1411-test"
    location            = "southeastasia"
    allocation_method   = "Static"
  }
  public_ip2 = {
    name                = "publicip2-test"
    resource_group_name = "resourcegroup1411-test"
    location            = "southeastasia"
    allocation_method   = "Static"
  }
}

vms = {
  vm1 = {
    name                 = "vm-1-test"
    resource_group_name  = "resourcegroup1411-test"
    location             = "southeastasia"
    size                 = "Standard_B1s"
    admin_username       = "adminuser"
    # admin_password ab yaha nahi likha jaata — Key Vault module isse generate/inject karta hai
    subnet_name          = "frontendsubnet1-test"
    public_ip_name       = "publicip1-test"
    virtual_network_name = "Terraformvnet1-test"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    offer                = "UbuntuServer"
    sku                  = "18.04-LTS"
    version              = "latest"
    publisher            = "Canonical"
  }
  vm2 = {
    name                 = "vm-2-test"
    resource_group_name  = "resourcegroup1411-test"
    location             = "southeastasia"
    size                 = "Standard_B1s"
    admin_username       = "adminuser"
    # admin_password ab yaha nahi likha jaata — Key Vault module isse generate/inject karta hai
    subnet_name          = "backendsubnet1-test"
    public_ip_name       = "publicip2-test"
    virtual_network_name = "Terraformvnet1-test"
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
    name                        = "keyvault1411-test"
    resource_group_name        = "resourcegroup1411-test"
    location                   = "southeastasia"
    sku_name                    = "standard"
    purge_protection_enabled    = false
    soft_delete_retention_days  = 7
  }
}

nsgs = {
  nsg_frontend = {
    name                = "nsg-frontend-test"
    location            = "southeastasia"
    resource_group_name = "resourcegroup1411-test"
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
    }
  }
  nsg_backend = {
    name                = "nsg-backend-test"
    location            = "southeastasia"
    resource_group_name = "resourcegroup1411-test"
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
}

tags = {
  Environment = "Test"
  Project     = "LandingZone"
  Owner       = "Vijay"
  ManagedBy   = "Terraform"
  CostCenter  = "IT-Test"
}

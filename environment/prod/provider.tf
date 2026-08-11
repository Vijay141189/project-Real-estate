terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.81.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }

  backend "azurerm" {
    resource_group_name  = "terraform-state-rg"
    storage_account_name = "tfstatestorage1411"
    container_name        = "tfstate"
    key                    = "prod.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
  resource_provider_registrations = "none"
}

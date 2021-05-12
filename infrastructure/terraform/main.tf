# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  }

  backend "azurerm" {
    resource_group_name  = "atnip-professional-development"
    storage_account_name = "pdaze1terrsa1"
    container_name       = "terraformdevops"
    key                  = "terraformdevops.tfstate"
  }

  required_version = ">= 0.14.3"
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "atnip-professional-development"
  location = "eastus"
}
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
    storage_account_name = "atnipaze1sa01"
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

resource "azurerm_storage_account" "function_storage" {
  name                      = "atnipaze1sa02"
  resource_group_name       = azurerm_resource_group.rg.name
  location                  = azurerm_resource_group.rg.location
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  enable_https_traffic_only = "true"
  account_kind              = "StorageV2"
  access_tier               = "Hot"
}

resource "azurerm_app_service_plan" "function_service_plan" {
  name                = "atnipaze1ap01"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  kind                = "FunctionApp"

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_function_app" "api_function_app" {
  name                       = "atnipaze1fa01"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  app_service_plan_id        = azurerm_app_service_plan.function_service_plan.id
  storage_account_name       = azurerm_storage_account.function_storage.name
  storage_account_access_key = azurerm_storage_account.function_storage.primary_access_key
  https_only                 = true
  version                    = "~3"
  enabled                    = true

  app_settings = merge(
    {
      FUNCTIONS_WORKER_RUNTIME = "dotnet-isolated"
      WEBSITE_RUN_FROM_PACKAGE = "1"
      FUNCTION_APP_EDIT_MODE   = "readonly"
      AZ_RESOURCE_GROUP        = azurerm_resource_group.rg.name
      GOOGLE_CLIENT_ID         = "456489038256-mabndspd8n3e3qlbgjug30n1trgmql1n.apps.googleusercontent.com"
    },
  )

  site_config {
    scm_type   = "VSTSRM"
    ftps_state = "Disabled"
  }

  lifecycle {
    ignore_changes = [
      app_settings["GIT_COMMIT_HASH"],
      app_settings["WEBSITE_ENABLE_SYNC_UPDATE_SITE"],
      site_config.0.scm_type
    ]
  }

  identity {
    type = "SystemAssigned"
  }

  depends_on = [
    azurerm_app_service_plan.function_service_plan,
  ]
}
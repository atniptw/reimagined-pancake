# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.92.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "VSSAZE1PDRG01"
    storage_account_name = "vssaze1pdsa01"
    container_name       = "terraformdevops"
    key                  = "terraformdevops.tfstate"
  }

  required_version = "~> 1.1.3"
}

provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "rg" {
  name = "VSSAZE1PDRG01"
}

# resource "azurerm_application_insights" "ai" {
#   name                = "pdaze1apimai01"
#   resource_group_name = "${data.azurerm_resource_group.rg.name}"
#   location            = "${data.azurerm_resource_group.rg.location}"
#   application_type    = "other"
#   retention_in_days   = 1
# }

resource "azurerm_api_management" "apim" {
  name                = "VSSAZE1PDAM01"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  publisher_name      = "Professional Development"
  publisher_email     = "atnip@sep.com"

  sku_name = "Developer_0"

  policy {
    xml_content = <<XML
    <policies>
      <inbound />
      <backend />
      <outbound />
      <on-error />
    </policies>
XML

  }
}

resource "azurerm_api_management_api" "project" {
  name                = "Project"
  resource_group_name = data.azurerm_resource_group.rg.name
  api_management_name = azurerm_api_management.apim.name
  revision            = "1"
  display_name        = "Project API"
  path                = "project"
  protocols           = ["https"]

  import {
    content_format = "openapi+json"
    content_value  = data.local_file.swagger.content
  }
}

data "local_file" "swagger" {
  filename = "${path.module}/swagger.json"
}

resource "azurerm_app_service_plan" "webappserviceplan" {
  name                = "VSSAZE1PDSP01"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  kind                = "App"

  sku {
    tier = "Free"
    size = "F1"
  }
}

resource "azurerm_app_service" "pdappservice" {
  name                = "VSSAZE1PDAS01"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  app_service_plan_id = azurerm_app_service_plan.webappserviceplan.id

  site_config {
    use_32_bit_worker_process = true
    dotnet_framework_version  = "v6.0"
    scm_type                  = "None"
  }

  depends_on = [
    azurerm_app_service_plan.webappserviceplan
  ]
}

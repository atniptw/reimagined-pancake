# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.92.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "PDAZE1APIMRG01"
    storage_account_name = "pdaze1apimsa01"
    container_name       = "terraformdevops"
    key                  = "terraformdevops.tfstate"
  }

  required_version = "~> 1.1.3"
}

provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "rg" {
  name     = "PDAZE1APIMRG01"
}

# resource "azurerm_application_insights" "ai" {
#   name                = "pdaze1apimai01"
#   resource_group_name = "${data.azurerm_resource_group.rg.name}"
#   location            = "${data.azurerm_resource_group.rg.location}"
#   application_type    = "other"
#   retention_in_days   = 1
# }

# resource "azurerm_api_management" "apim" {
#   name                = "pdaze1apimam01"
#   resource_group_name = "${data.azurerm_resource_group.rg.name}"
#   location            = "${data.azurerm_resource_group.rg.location}"
#   publisher_name      = "Professional Development"
#   publisher_email     = "atnip@sep.com"

#   sku_name = "Consumption_0"

#   policy {
#     xml_content = <<XML
#     <policies>
#       <inbound />
#       <backend />
#       <outbound />
#       <on-error />
#     </policies>
# XML

#   }
# }

resource "azurerm_app_service_plan" "webappserviceplan" {
  name                = "api-appserviceplan-pro"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
  location            = "${data.azurerm_resource_group.rg.location}"
  kind                = "Linux"

  sku {
    tier = "Free"
    size = "F1"
  }
}

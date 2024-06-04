data "azurerm_client_config" "current" {}

locals {
  ws_name = "${terraform.workspace}"                          # Get the current workspace name. The YAML file selects the workspace to use first before running the Terraform commands.
  create_resource = terraform.workspace == "prod"
}

# Create a resource group
resource "azurerm_resource_group" "rg" {
  count   = local.create_resource ? 1 : 0                     # Create the resource group only in the prod environment
  name     = var.resource_group_name
  location = var.location
}

# Create a key vault
resource "azurerm_key_vault" "kv" {
  name                = "san-calyinfra-kv-${var.resource_name_suffix}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"
}

# Create an app service plan
resource "azure_app_service_plan" "asp" {
  name                = "san-calyinfra-asp-${var.resource_name_suffix}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Standard"
    size = "S1"
  }
}




data "azurerm_client_config" "current" {}

locals {
  ws_name = "${terraform.workspace}"                          # Get the current workspace name. The YAML file selects the workspace to use first before running the Terraform commands.

  only_in_prod = {
    prod = true
    non_prod = false
  }

  resource_name_suffix = {
    prod = "prod"
    non_prod = "nonprod"
  }

  rg_reader_principal_id = {
    prod = "00000000-0000-0000-0000-000000000000"             # Replace with the actual reader principal ID
    non_prod = "11111111-1111-1111-1111-111111111111"         # Replace with the actual reader principal ID
  }

  rg_contributor_principal_id = {
    prod = "22222222-2222-2222-2222-222222222222"             # Replace with the actual contributor principal ID
    non_prod = "33333333-3333-3333-3333-333333333333"         # Replace with the actual contributor principal ID
  }
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_key_vault" "kv" {
  name                = "san-calyinfra-kv"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"
}


resource "azure_app_service_plan" "asp" {
  name                = "san-calyinfra-asp"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Standard"
    size = "S1"
  }
  count = local.only_in_prod[terraform.workspace]
}


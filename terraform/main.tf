data "azurerm_client_config" "current" {}

locals {
  ws_name                               = "${terraform.workspace}"                          # Get the current workspace name. The YAML file selects the workspace to use first before running the Terraform commands.
  create_resource                       = terraform.workspace == "prod"
}

# Create a resource group
resource "azurerm_resource_group" "rg" {
  # count   = local.create_resource ? 1 : 0                      Create the resource group only in the prod environment
  name                                  = "${var.resource_group_name}-${local.ws_name}"
  location                              = var.location
}

# Create a key vault
resource "azurerm_key_vault" "kv" {
  name                                  = "san-calyinfra-kv-${var.resource_name_suffix}"
  location                              = azurerm_resource_group.rg.location
  resource_group_name                   = azurerm_resource_group.rg.name
  tenant_id                             = data.azurerm_client_config.current.tenant_id
  sku_name                              = "standard"
}

# Create a storage account
resource "azurerm_storage_account" "sa" {
  name                                  = "san-calyinfra-sa-${var.resource_name_suffix}"
  resource_group_name                   = azurerm_resource_group.rg.name
  location                              = azurerm_resource_group.rg.location
  account_tier                          = "Standard"
  account_replication_type              = "LRS"
}

# Create a container
resource "azurerm_storage_container" "sc" {
  name                                  = "san-calyinfra-sc-${var.resource_name_suffix}"
  storage_account_name                  = azurerm_storage_account.sa.name
  container_access_type                 = "private"
}

# Create a SQL server
resource "azurerm_mssql_server" "ss" {
  name                                  = "san-calyinfra-ss-${var.resource_name_suffix}"
  resource_group_name                   = azurerm_resource_group.rg.name
  location                              = azurerm_resource_group.rg.location
  version                               = "12.0"
  minimum_tls_version                   = "1.2"

  azuread_administrator {
    azuread_authentication_only         = true
    login_username                      = "carolp1962@gmail.com"
    object_id                           = var.object_id
  }

}

# Create a SQL database
resource "azurerm_mssql_database" "sdb" {
  name                                  = "san-calyinfra-sdb-${var.resource_name_suffix}"
  server_id                             = azurerm_mssql_server.ss.id
  collation                             = "SQL_Latin1_General_CP1_CI_AS"
  max_size_gb                           = 1
  read_scale                            = false
  sku_name                              = "Basic"
   
}





terraform {

    # Initialize all the providers required for the infrastructure (These providers are automatically downloaded and installed by Terraform when you run terraform init command)
    required_providers {
        azurerm = {
            source = "hashicorp/azurerm"
            version = "~> 3.0"
        }
    }

    # Setup the backend to store the state files
    backend "azurerm" {
        resource_group_name   = "san-calybackend-rg"        # The name of the resource group
        storage_account_name  = "san-calybackend-blob"      # The name of the storage account
        container_name        = "tfstate"                   # The name of the container in the storage account
        key                   = "terraform.tfstate"         # The name of the state file in the container
    }
}

# Define a particular provider you want to build the infrastructure on
provider "azurerm" {
    features {}
}
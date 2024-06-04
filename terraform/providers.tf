terraform {

    # Initialize all the providers required for the infrastructure (These providers are automatically downloaded and installed by Terraform when you run terraform init command)
    required_providers {
        azurerm = {
            source = "hashicorp/azurerm"
            version = "~> 3.0"
        }
    }

    # Setup the backend to store the state file
    backend "azurerm" {
        resource_group_name   = "rg-terraform-state"
        storage_account_name  = "stterraformstate"
        container_name        = "tfstate"
        key                   = "terraform.tfstate"
    }
}

# Define a particular provider you want to build the infrastructure on
provider "azurerm" {
    features {}
}
# Specify the variable types that will be used in the Terraform configuration.
variable "location" {
  type = string
  description = "Azure resource deployment region. If this variable is set to `null` it would use resource group's location."
}

variable "resource_group_name" {
  type = string
  description = "The name of the resource group"
}

variable "resource_name_suffix" {
  type = string
  description = "The suffix to be appended to the resource name based on the environment"
}

variable "rg_reader_principal_id" {
  type = string
  description = "The reader principal ID for the resource group"
}

variable "rg_contributor_principal_id" {
  type = string
  description = "The contributor principal ID for the resource group"
}

variable "only_in_prod" {
  type = bool
  description = "A boolean value that is true only in the prod environment"
}
# Azure Provider source and version 
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.94.0"
    }
  }
  required_version = ">= 1.1.0"
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  subscription_id = "f8f0dbc6-70ae-4418-b8bf-7b7d76dad606"
}
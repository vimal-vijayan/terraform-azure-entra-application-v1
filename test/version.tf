terraform {
  required_providers {
    azuread = {
      source = "hashicorp/azuread"
      version = "3.0.2"
    }
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.11.0"
    }
  }
}

provider "azuread" {
  # Configuration options
}

provider "azurerm" {
  # Configuration options
  features {
    # Configuration options
  }
  subscription_id = "4ca0540a-c95a-4d35-b76a-b68ece41f769"
}
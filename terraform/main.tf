terraform {
  required_version = ">= 1.8.0"

  backend "azurerm" {
    container_name   = "terraform"
    key              = "infra-system.terraform.tfstate"
    use_azuread_auth = true
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.107.0"
    }
  }
}

provider "azurerm" {
  subscription_id     = var.sub_id
  storage_use_azuread = true

  features {}
}

variable "sub_id" {}
variable "env" {
  
}

data "azurerm_subscription" "sub" {}

output "subid" {
  value = data.azurerm_subscription.sub.subscription_id
}

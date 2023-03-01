terraform {
  required_providers {
    azurerm = "3.45.0"
  }
}

provider "azurerm" {
  features {}
}


data "azurerm_client_config" "current" {
}

data "external" "me" {
  program = ["az", "account", "show", "--query", "user"]
}


data "azurerm_resource_group" "this" {
  name     = "Devops-RG"
}

resource "azurerm_databricks_workspace" "this" {
  name                        = "${var.prefix}-workspace"
  resource_group_name         = data.azurerm_resource_group.this.name 
  location                    = data.azurerm_resource_group.this.location
  sku                         = "standard"
  managed_resource_group_name = "${var.prefix}-workspace-rg"
  tags                        = {
    "created_by" = "Terraform"
  }
}

output "databricks_host" {
  value = "https://${azurerm_databricks_workspace.this.workspace_url}/"
}
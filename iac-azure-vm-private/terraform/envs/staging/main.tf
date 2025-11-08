locals {
  name = "${var.project_name}-${var.env}"
}

resource "azurerm_resource_group" "rg" {
  name = "rg-${local.name}"
  location = var.location
}

output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}
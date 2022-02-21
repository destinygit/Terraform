# Create a resource group
# rg-bb-shared-zan-001
resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.business}-${var.base_name}-${var.shortlocation}-${var.numberseq}"
  location = var.region
  #tags     = var.tags
  tags = merge({
    created_on   = var.created_on
  }, var.tags)
}

output "id" {
  value = azurerm_resource_group.rg.id
}

output "name2" {
  value = azurerm_resource_group.rg.name
}

resource "azurerm_storage_account" "diag_storage" {
  name                     = var.storage_name
  resource_group_name      = var.rg_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags                     = merge({
                                created_on   = var.created_on
                            }, var.tags)
}
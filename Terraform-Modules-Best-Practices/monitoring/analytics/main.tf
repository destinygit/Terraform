resource "azurerm_log_analytics_workspace" "loganalytics" {
  name                = var.analytics_name
  location            = var.location
  resource_group_name = var.rg_name
  sku                 = "Standard"
  retention_in_days   = 30

  tags                = merge({
                            created_on   = var.created_on
                        }, var.tags)
}
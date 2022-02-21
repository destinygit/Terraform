resource "azurerm_virtual_network" "vnet" {
  name                = var.base_name
  location            = var.location
  resource_group_name = var.rg_name

  address_space       = var.address_spaces
  dns_servers         = var.dns_servers

  tags                = merge({
                          created_on   = var.created_on
                        }, var.tags)
}
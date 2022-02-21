# resource "azurerm_resource_group" "example" {
#   name     = "example-resources"
#   location = "West Europe"
# }
# resource "azurerm_virtual_network" "example" {
#   name                = "example-network"
#   location            = azurerm_resource_group.example.location
#   resource_group_name = azurerm_resource_group.example.name
#   address_space       = ["10.0.0.0/16"]
# }
resource "azurerm_virtual_wan" "vwan" {
  name                = var.vwan_name
  resource_group_name = var.rg_name
  location            = var.location
}
resource "azurerm_virtual_hub" "vhub" {
  name                = var.vhub_name
  resource_group_name = var.rg_name
  location            = var.location
  virtual_wan_id      = azurerm_virtual_wan.vwan.id
  address_prefix      = var.address_prefix
}
resource "azurerm_vpn_gateway" "vpngw" {
  name                = var.vpngw_name
  location            = var.location
  resource_group_name = var.rg_name
  virtual_hub_id      = azurerm_virtual_hub.vhub.id

  tags                = merge({
                          created_on   = var.created_on
                        }, var.tags)
}
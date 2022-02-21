# resource "azurerm_resource_group" "example" {
#   name     = "example-resources"
#   location = "West Europe"
# }

resource "azurerm_public_ip" "azbaspubip" {
  name                = var.pubipname
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}
resource "azurerm_bastion_host" "azbastion" {
  name                = var.bastionname
  location            = var.location
  resource_group_name = var.resource_group_name
  ip_configuration {
    name                 = "configuration"
    subnet_id            = var.azurerm_subnet_id
    public_ip_address_id = azurerm_public_ip.azbaspubip.id
  }
  tags                     = merge({
                                created_on   = var.created_on
                            }, var.tags)
}
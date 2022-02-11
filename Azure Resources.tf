
#az login to connect terraform to Azure
#az account set --subscription "subcription id or Name" >> will set the subsription terraform will deploy to
#Specify Azure Provider source -- version[az cli version] use atleast(~>) at or exceeding the version we currently at
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.33.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
}

# Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = "terraform-rg"
  location = "South Africa North"
  tags = {
    Environment = "Dev"
    location    = "South Africa North"
    Owner       = "VR"
    Resource    = "Resource Group"
  }
}
#Create Storage account
resource "azurerm_storage_account" "sa" {
  name                     = "tfsacc"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags = {
    Environment = "Dev"
    location    = "South Africa North"
    Owner       = "VR"
    Resource    = "Storage account"
  }

}
# Create a azure data factory
resource "azurerm_data_factory" "adf" {
  name                = "tf-bdnav-adf"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags = {
    Environment = "Dev"
    location    = "South Africa North"
    Owner       = "VR"
    Resource    = "Data Factory"
  }
}
# Create a azure Blob Linked Service
resource "azurerm_data_factory_linked_service_azure_blob_storage" "ls" {
  name                = "tf-blob=linkedservice"
  resource_group_name = azurerm_resource_group.rg.name
  data_factory_name   = azurerm_data_factory.adf.name
  connection_string   = resource.azurerm_storage_account.sa.primary_connection_string

}
#blob dataset
resource "azurerm_data_factory_dataset_azure_blob" "ds" {
  name                = "example"
  resource_group_name = azurerm_resource_group.rg.name
  data_factory_name   = azurerm_data_factory.adf.name
  linked_service_name = azurerm_data_factory_linked_service_azure_blob_storage.ls.name

  path     = "Raw"
  filename = ".csv"
}
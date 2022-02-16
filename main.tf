#az login to connect terraform to Azure
#az account set --subscription "subcription id or Name" >> will set the subsription terraform will deploy to

#Specify Azure Provider source -- version[az cli version] 

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
  subscription_id = "${var.subscription_id}"
  tenant_id       = "${var.tenant_id}"
}

# Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = "Terraform"
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
  name                     = "tfmetaaccount"
  resource_group_name      = "${azurerm_resource_group.rg.name}"
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = "true"
  tags = {
    Environment = "Dev"
    location    = "South Africa North"
    Owner       = "VR"
    Resource    = "Storage account"
  }
}

#output block will display the result of the resource
#data argument stores the data from the attached resource
data "storage" "ssa" {
  name = azurerm_storage_account.sa.name
  resource_group_name = azurerm_resource_group.rg.name
}

output "tsa" {
  value = data.storage.ssa
}

/*
#Create az storage data lake gen2 file system
resource "azurerm_storage_data_lake_gen2_filesystem" "adlsfs" {
  name               = "fs-lakestore"
  storage_account_id = azurerm_storage_account.sa.id

  properties = {
    hello = "code123"
  }
}
*/
/*
#output block will display the result of the resource
#data argument stores the data from the attached resource
data "lakestorage" "lsa" {
  name = azurerm_storage_account.sa.name
  resource_group_name = azurerm_resource_group.rg.name
}


output "adlsfs" {
  value = data.azurerm_storage_data_lake_gen2_filesystem.adlsfs
}
*/
/*
#create az storage data lake gen2 path
resource "azurerm_storage_data_lake_gen2_path" "adlsp" {
  path               = "metadata"
  filesystem_name    = azurerm_storage_data_lake_gen2_filesystem.adlsfs.name
  storage_account_id = azurerm_storage_account.sa.id
  resource           = "directory"
}
*/

/*
#output block will display the result of the resource
#data argument stores the data from the attached resource
output "adlsp" {
  value = data.azurerm_storage_data_lake_gen2_path.adlsp
}
*/

#Get current tenantid and my objectid
data "azurerm_client_config" "current" {}

#create az keavault and secrets
resource "azurerm_key_vault" "kv" {
  name                       = "tf-secretsvault"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "premium"
  soft_delete_retention_days = 7

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Backup", "Create", "Decrypt",
      "Delete", "Encrypt", "Get",
      "Import", "List", "Purge",
      "Recover", "Restore", "Sign",
      "UnwrapKey", "Update", "Verify", "WrapKey"
    ]

    secret_permissions = [
      "set", "backup", "restore",
      "get", "list",
      "delete",
      "purge",
      "recover",
    ]
    certificate_permissions = [
      "Backup", "Create", "Delete",
      "Get", "List",
      "Recover",
      "Restore",
    ]


  }
}


data "azurerm_key_vault_secret" "secret" {
  key_key_vault_name = azurerm_key_vault.kv.name
  resource_group_name = azurerm_resource_group.rg.name
}
output "kvo" {
  value = data.azurerm_key_vault_secret.secret
}

#create az SQL Server
resource "azurerm_sql_server" "sqls" {
  name                         = "sql-server-meta"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  version                      = "12.0"
  administrator_login          = "azureadmin"
  administrator_login_password = azurerm_key_vault_secret.secret.value

  tags = {
    Environment = "Dev"
    location    = "South Africa North"
    Owner       = "VR"
    Resource    = "Sql Server"
  }
}

#create az SQL Database
resource "azurerm_sql_database" "db" {
  name                = "config"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  server_name         = azurerm_sql_server.sqls.name

  extended_auditing_policy {
    storage_endpoint                        = azurerm_storage_account.sa.primary_blob_endpoint
    storage_account_access_key              = azurerm_storage_account.sa.primary_access_key
    storage_account_access_key_is_secondary = true
    retention_in_days                       = 6
  }



  tags = {
    Environment = "Dev"
    location    = "South Africa North"
    Owner       = "VR"
    Resource    = "Sql DataBase"
  }
}

# Create a azure data factory
resource "azurerm_data_factory" "adf" {
  name                = "config-adf"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags = {
    Environment = "Dev"
    location    = "South Africa North"
    Owner       = "VR"
    Resource    = "Data Factory"
  }
}
# Create a azure data lake gen2 Linked Service
resource "azurerm_data_factory_linked_service_data_lake_storage_gen2" "lsadls" {
  name                  = "datalakegen2"
  resource_group_name   = azurerm_resource_group.rg.name
  data_factory_name     = azurerm_data_factory.adf.name
  service_principal_id  = data.azurerm_client_config.current.client_id
  service_principal_key = "adfsp"
  tenant                = data.azurerm_client_config.current.tenant_id
  url                   = "https://tfmetaaccount.dfs.core.windows.net/" #@linkedService().StorageAccountURL
  parameters            = { "StorageAccountURL" : "placeholder" }
}

#create azure ketvault linked service
resource "azurerm_data_factory_linked_service_key_vault" "lskv" {
  name                = "secretvault"
  resource_group_name = azurerm_resource_group.rg.name
  data_factory_name   = azurerm_data_factory.adf.name
  key_vault_id        = azurerm_key_vault.kv.id
  parameters          = { "AzureKeyVaultURL" : "placeholder" }
}

/*
#create az SQL Database linked service
#create sql DB first then use keyvault to store connection string
data "azurerm_sql_database" "ddb" {
  name = azurerm_sql_database.db.name
  server_name = azurerm_sql_database.db.server_name
  resource_group_name = azurerm_resource_group.rg.name
  
}

output "datasqldb" {
  value = azurerm_sql_database.ddb.connection_string
}
resource "azurerm_data_factory_linked_service_azure_sql_database" "lsdb" {
  name                = "Config"
  resource_group_name = azurerm_resource_group.rg.name
  data_factory_id     = azurerm_data_factory.adf.id
  connection_string   = azurerm_sql_database.db.c
}
*/

/* 
resource "azurerm_data_factory_linked_service_sql_server" "lssqls" {
  name                = "lssqlServer"
  resource_group_name = azurerm_resource_group.rg.name
  data_factory_id     = azurerm_data_factory.adf.id
  connection_string   = "Integrated Security=False;Data Source=test;Initial Catalog=test;User ID=test;Password=test"
   key_vault_password {
    linked_service_name = azurerm_data_factory_linked_service_key_vault.lskv.name
    secret_name         = "secret"
  }
}
*/

#blob dataset
resource "azurerm_data_factory_dataset_azure_blob" "dsbs" {
  name                = "adlsstorageacc"
  resource_group_name = azurerm_resource_group.rg.name
  data_factory_name   = azurerm_data_factory.adf.name
  linked_service_name = azurerm_data_factory_linked_service_data_lake_storage_gen2.lsadls.name
  parameters = {
    "Filesystem" : "placeholder"
    "Directory" : "placeholder"
    "FileName" : "placeholder"

  }

  path     = "@dataset().Filesystem"  #hardcode placeholder as they would appear in adf 
  filename = "@dataset().FileName"
}

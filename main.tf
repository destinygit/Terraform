
#az login to connect terraform to Azure
#az account set --subscription "subcription id or Name" >> will set the subsription terraform will deploy to

#---------------------------------------------------------------------------------------------
#Specify Azure Provider source -- version[az cli version] 
#---------------------------------------------------------------------------------------------
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.33.0"
    }
  }
}
#---------------------------------------------------------------------------------------------
# Configure the Microsoft Azure Provider
#---------------------------------------------------------------------------------------------
provider "azurerm" {
  features {}
  subscription_id = "${var.subscription_id}"
  tenant_id       = "${var.tenant_id}"
  client_secret   = "${var.Client_Secrets}"
  client_id       = "${var.Client_Id}"
}

#---------------------------------------------------------------------------------------------
#Resources required first ###1
#---------------------------------------------------------------------------------------------

#1 Create a resource group
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
#2 Create Storage account
resource "azurerm_storage_account" "sa" {
  name                     = "tfmetaaccount"
  resource_group_name      = azurerm_resource_group.rg.name
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

#---------------------------------------------------------------------------------------------
#Get current tenantid and my objectid
#---------------------------------------------------------------------------------------------

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
#---------------------------------------------------------------------------------------------
#Get Key_Vault Secrets
#---------------------------------------------------------------------------------------------

#First, call azure key vault resource
data "azurerm_key_vault" "dkv" {
  name                = azurerm_key_vault.kv.name
  resource_group_name = azurerm_resource_group.rg.name
}

#Then, call individual secrets from the key vault [Dtatbase connection string]
data "azurerm_key_vault_secret" "dbsecret" {
  name         = "dbconnectionstring"
  key_vault_id = azurerm_key_vault.kv.id
}

#Sql Server password
data "azurerm_key_vault_secret" "sqlsecret" {
  name         = "sqlPassword"
  key_vault_id = azurerm_key_vault.kv.id
}

#Sql Server connectionstring
data "azurerm_key_vault_secret" "sqlcsecret" {
  name         = "Sqlserverconnectionstring"
  key_vault_id = azurerm_key_vault.kv.id
}

#MySql Server connectionstring
data "azurerm_key_vault_secret" "Msqlcsecret" {
  name         = "Mysqlconnectionstring"
  key_vault_id = azurerm_key_vault.kv.id
}

#PostgresSQL connectionstring
data "azurerm_key_vault_secret" "Psqlcsecret" {
  name         = "postgresconnectionstring"
  key_vault_id = azurerm_key_vault.kv.id
}

/* Working output values of the resource [key_vault]
output "kvo" {
  value = data.azurerm_key_vault.dkv
}
*/

#create az SQL Server
resource "azurerm_sql_server" "sqls" {
  name                         = "sql-server-meta"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  version                      = "12.0"
  administrator_login          = "azureadmin"
  administrator_login_password = data.azurerm_key_vault_secret.sqlsecret.value

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

#---------------------------------------------------------------------------------------------
#Create Linked Services ###2
#---------------------------------------------------------------------------------------------

# Create a azure data lake gen2 Linked Service
resource "azurerm_data_factory_linked_service_data_lake_storage_gen2" "lsadls" {
  name                  = "datalakegen2"
  resource_group_name   = azurerm_resource_group.rg.name
  data_factory_name     = azurerm_data_factory.adf.name
  service_principal_id  = data.azurerm_client_config.current.client_id
  service_principal_key = "adfsp"
  tenant                = data.azurerm_client_config.current.tenant_id
  url                   = "https://tfmetaaccount.dfs.core.windows.net/" #requires a link, not placeholder[@linkedService().StorageAccountURL]
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

#create azure SQL Database linked service
resource "azurerm_data_factory_linked_service_azure_sql_database" "lsdb" {
  name                = "Config"
  resource_group_name = azurerm_resource_group.rg.name
  data_factory_name   = azurerm_data_factory.adf.name
  connection_string   = data.azurerm_key_vault_secret.dbsecret.value
  parameters = {
    "SQLServerURL" : "placeholder"
    "SQLserverDatabaseName" : "placeholder"


  }
}

#create azure SQL Server linked service
resource "azurerm_data_factory_linked_service_sql_server" "lssqls" {
  name                = "lssqlServer"
  resource_group_name = azurerm_resource_group.rg.name
  data_factory_name   = azurerm_data_factory.adf.name
  connection_string   = data.azurerm_key_vault_secret.sqlcsecret.value #create SQl server & DB first, to get the connection string, or use placeholder
  parameters = {
    "SQLServerName" : "placeholder"
    "SQLDatabaseName" : "placeholder"
    "AzureKeyVaultURL" : "placeholder"
    "SQLAuthUserName" : "placeholder"
    "AzureKeyVaultSecretName" : "placeholder"

  }
}

#create azure MySQL Server linked service
resource "azurerm_data_factory_linked_service_mysql" "lsMysql" {
  name                = "MySqlservice"
  resource_group_name = azurerm_resource_group.rg.name
  data_factory_name   = azurerm_data_factory.adf.name
  connection_string   = data.azurerm_key_vault_secret.Psqlcsecret.value
  parameters = {
    "MSQLServerName" : "placeholder"
    "MSQLDatabaseName" : "placeholder"
    "AzureKeyVaultURL" : "placeholder"
    "MSQLAuthUserName" : "placeholder"
    "AzureKeyVaultSecretName" : "placeholder"

  }
}

#create azure PostgreSQl Server linked service
resource "azurerm_data_factory_linked_service_postgresql" "lsPsql" {
  name                = "PostgresSql"
  resource_group_name = azurerm_resource_group.rg.name
  data_factory_name   = azurerm_data_factory.adf.name
  connection_string   = data.azurerm_key_vault_secret.Msqlcsecret.value
  parameters = {
    "PSQLServerName" : "placeholder"
    "PSQLDatabaseName" : "placeholder"
    "AzureKeyVaultURL" : "placeholder"
    "PSQLAuthUserName" : "placeholder"
    "AzureKeyVaultSecretName" : "placeholder"

  }
}

#create azure HTTP linked service
resource "azurerm_data_factory_linked_service_web" "lsHttp" {
  name                = "Httpservice"
  resource_group_name = azurerm_resource_group.rg.name
  data_factory_name   = azurerm_data_factory.adf.name
  authentication_type = "@{linkedService().HTTPAuthenticationType}"
  url                 = "http://www.bing.com"
  parameters = {
    "HTTPAuthenticationType" : "placeholder"
    "HttpURL" : "placeholder"
  }
}

#create SFTP linked service
resource "azurerm_data_factory_linked_service_sftp" "lsSftp" {
  name                = "SFTP"
  resource_group_name = azurerm_resource_group.rg.name
  data_factory_name   = azurerm_data_factory.adf.name

  authentication_type = "@{linkedService().AuthenticationType}"
  host                = "http://www.bing.com"
  port                = 22
  username            = "@{linkedService().Username}"
  password            = "@{linkedService().AzureKeyVaultPassword}"

  parameters = {
    "AuthenticationType"    = "placeholder"
    "Host"                  = "placeholder"
    "Port"                  = 22
    "Username"              = "placeholder"
    "AzureKeyVaultPassword" = "placeholder"
  }
}

#---------------------------------------------------------------------------------------------
#Create Datasets ###3
#---------------------------------------------------------------------------------------------

#Create azure storageg2 dataset
resource "azurerm_data_factory_dataset_azure_blob" "dsbs" {
  name                = "Source_Lake"
  resource_group_name = azurerm_resource_group.rg.name
  data_factory_name   = azurerm_data_factory.adf.name
  linked_service_name = azurerm_data_factory_linked_service_data_lake_storage_gen2.lsadls.name
  parameters = {
    "Filesystem" : "placeholder"
    "Directory" : "placeholder"
    "FileName" : "placeholder"

  }

  path     = "@dataset().Filesystem" #hardcode placeholder as they would appear in adf 
  filename = "@dataset().FileName"
}

#Create SQL Server table dataset
resource "azurerm_data_factory_dataset_sql_server_table" "dsSQls" {
  name                = "Source_SQLServer"
  resource_group_name = azurerm_resource_group.rg.name
  data_factory_name   = azurerm_data_factory.adf.name
  linked_service_name = azurerm_data_factory_linked_service_sql_server.lssqls.name
  parameters = {
    "SQLServerName" : "GenericOnPremSqlServerName"
    "SQLDatabaseName" : "GenericDatabaseName"
    "AzureKeyVaultURL" : "KeyVaultURL"
    "SQLAuthUserName" : "SQLAuthUserName"
    "AzureKeyVaultURL" : "KeyvaultURL"
    "SQLAuthenticationPasswordAzureKeyVaultSecretName" : "SQL Password in KeyVault"
    "SchemaName" : "TableMySchemaName"
    "ObjectName" : "TableObjectName"

  }
}

#Create PostgresSQL Server table dataset
resource "azurerm_data_factory_dataset_postgresql" "dsPsql" {
  name                = "Source_PostgreSQL"
  resource_group_name = azurerm_resource_group.rg.name
  data_factory_name   = azurerm_data_factory.adf.name
  linked_service_name = azurerm_data_factory_linked_service_postgresql.lsPsql.name
  parameters = {
    "PSQLServerName" : "GenericOnPremSqlServerName"
    "PSQLDatabaseName" : "GenericDatabaseName"
    "AzureKeyVaultURL" : "KeyVaultURL"
    "PSQLAuthUserName" : "SQLAuthUserName"
    "AzureKeyVaultURL" : "KeyvaultURL"
    "PSQLAuthenticationPasswordAzureKeyVaultSecretName" : "SQL Password in KeyVault"
    "SchemaName" : "TableMySchemaName"
    "ObjectName" : "TableObjectName"

  }
}

#Create MySql Server table dataset
resource "azurerm_data_factory_dataset_mysql" "dsMsql" {
  name                = "Source_MySQl"
  resource_group_name = azurerm_resource_group.rg.name
  data_factory_name   = azurerm_data_factory.adf.name
  linked_service_name = azurerm_data_factory_linked_service_mysql.lsMysql.name
  parameters = {
    "MSQLServerName" : "GenericOnPremSqlServerName"
    "MSQLDatabaseName" : "GenericDatabaseName"
    "AzureKeyVaultURL" : "KeyVaultURL"
    "MSQLAuthUserName" : "SQLAuthUserName"
    "AzureKeyVaultURL" : "KeyvaultURL"
    "MSQLAuthenticationPasswordAzureKeyVaultSecretName" : "SQL Password in KeyVault"
    "SchemaName" : "TableMySchemaName"
    "ObjectName" : "TableObjectName"

  }
}

#Create HTTP dataset
resource "azurerm_data_factory_dataset_http" "dsHTTP" {
  name                = "Source_HTTP"
  resource_group_name = azurerm_resource_group.rg.name
  data_factory_name   = azurerm_data_factory.adf.name
  linked_service_name = azurerm_data_factory_linked_service_web.lsHttp.name

  relative_url   = "http://www.bing.com"
  request_body   = "@dataset().RequestBody"
  request_method = "@dataset().RequestMethod"

  parameters = {
    "RelativeURL" : "placeholder"
    "RequestBody" : "placeholder"
    "RequestMethod" : "placeholder"

  }
}



#---------------------------------------------------------------------------------------------
#Integration Runtime ###4
#---------------------------------------------------------------------------------------------

#Create Self Hosted Integration Runtime
resource "azurerm_data_factory_integration_runtime_self_hosted" "Irsh" {
  name                = "SelfHostedIR"
  resource_group_name = azurerm_resource_group.rg.name
  data_factory_name   = azurerm_data_factory.adf.name
}
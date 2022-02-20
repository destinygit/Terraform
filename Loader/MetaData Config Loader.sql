CREATE PROCEDURE SpExecConfig
AS


CREATE TABLE [LoadConfig] (
  [LoadConfigId] int PRIMARY KEY NOT NULL IDENTITY(1, 1),
  [BusinessAreaId] int,
  [LoadTypeId] int,
  [SourceDataFactoryId] int,
  [SourceIntgrationRuntimeId] int,
  [SourceLinkedServiceId] int,
  [SourceLinkedServicePropertySetId] int,
  [SourceEntityId] int NOT NULL,
  [TargetDataFactoryId] int,
  [TargetIntegrationRuntimeId] int,
  [TargetLinkedServiceId] int,
  [TargetLinkedServicePropertySetId] int,
  [TargetEntityId] int NOT NULL,
  [DeltaWatermarkId] int NOT NULL,
  [ScheduleId] int,
  [Tags] varchar(1000),
  [ExecutionStatusTypeId] int,
  [LastExecutionStartTime] datetime2,
  [LastExecutionResult] tinyint,
  [IsActive] bit NOT NULL
)
GO

CREATE TABLE [DeltaWatermark] (
  [DeltaWatermarkId] int PRIMARY KEY NOT NULL IDENTITY(1, 1),
  [DeltaWatermarkType] varchar(50) NOT NULL,
  [DeltaWatermarkDefinition] varchar(1000),
  [DeltaWatermarkDataType] varchar(30),
  [DeltaWatermarkValue] varchar(100)
)
GO

CREATE TABLE [ExecutionStatusType] (
  [ExecutionStatusTypeId] int PRIMARY KEY NOT NULL IDENTITY(1, 1),
  [ExecutionStatusTypeName] varchar(100) NOT NULL
)
GO

CREATE TABLE [Schedule] (
  [ScheduleId] int PRIMARY KEY NOT NULL IDENTITY(1, 1),
  [ScheduleName] varchar(100) NOT NULL,
  [ScheduleFrequency] decimal NOT NULL,
  [ScheduleFrequencyUnit] varchar(50) NOT NULL
)
GO

CREATE TABLE [BatchTrigger] (
  [BatchTriggerId] int PRIMARY KEY NOT NULL IDENTITY(1, 1),
  [BatchTriggerName] varchar(100) NOT NULL,
  [BatchTriggerFrequency] decimal NOT NULL,
  [BatchTriggerUnit] varchar(50) NOT NULL
)
GO

CREATE TABLE [BusinessArea] (
  [BusinessAreaId] int PRIMARY KEY NOT NULL IDENTITY(1, 1),
  [BusinessAreaName] varchar(100) NOT NULL
)
GO

CREATE TABLE [LoadType] (
  [LoadTypeId] int PRIMARY KEY NOT NULL IDENTITY(1, 1),
  [LoadTypeName] nvarchar(255) NOT NULL CHECK ([LoadTypeName] IN ('BatchFullLoad', 'BatchDeltaLoad', 'Stream', 'OnceOff')) 
)
GO

CREATE TABLE [Tennant] (
  [TennantId] int PRIMARY KEY NOT NULL IDENTITY(1, 1),
  [TennantGUID] uniqueidentifier NOT NULL,
  [TennantName] varchar(100)
)
GO

CREATE TABLE [Subscription] (
  [SubscriptionId] int PRIMARY KEY NOT NULL IDENTITY(1, 1),
  [SubscriptionGUID] uniqueidentifier NOT NULL,
  [SubscriptionName] varchar(100),
  [TennantId] int
)
GO

CREATE TABLE [ResourceGroup] (
  [ResourceGroupId] int PRIMARY KEY NOT NULL IDENTITY(1, 1),
  [ResourceGroupGUID] uniqueidentifier NOT NULL,
  [ResourceGroupName] varchar(100),
  [ResourceGroupLocation] varchar(100),
  [SubscriptionId] int
)
GO

CREATE TABLE [DataFactory] (
  [DataFactoryId] int PRIMARY KEY NOT NULL IDENTITY(1, 1),
  [DataFactoryGUID] uniqueidentifier NOT NULL,
  [DataFactoryName] varchar(100) NOT NULL,
  [ResourceGroupId] int,
  [DataFactoryLocation] varchar(100)
)
GO

CREATE TABLE [IntegrationRuntimeType] (
  [IntegrationRuntimeTypeId] int PRIMARY KEY NOT NULL IDENTITY(1, 1),
  [IntegrationRuntimeTypeName] nvarchar(255) NOT NULL CHECK ([IntegrationRuntimeTypeName] IN ('Azure', 'SelfHosted', 'SSIS')) 
)
GO

CREATE TABLE [IntegrationRuntimeSubType] (
  [IntegrationRuntimeSubTypeId] int PRIMARY KEY NOT NULL IDENTITY(1, 1),
  [IntegrationRuntimeSubTypeName] varchar(100) NOT NULL
)
GO

CREATE TABLE [IntegrationRuntime] (
  [IntegrationRuntimeId] int PRIMARY KEY NOT NULL IDENTITY(1, 1),
  [IntegrationRuntimeName] varchar(100) NOT NULL,
  [IntegrationRuntimeTypeId] int,
  [IntegrationRuntimeSubTypeId] int,
  [IntegrationRuntimeLocation] int,
  [DataFactoryId] int
)
GO

CREATE TABLE [IntegrationRuntimeNode] (
  [IntegrationRuntimeNodeId] int PRIMARY KEY NOT NULL IDENTITY(1, 1)
)
GO

CREATE TABLE [LinkedServicePropertyType] (
  [LinkedServicePropertyTypeId] int PRIMARY KEY NOT NULL IDENTITY(1, 1),
  [LinkedServicePropertyTypeName] varchar(100) NOT NULL,
  [LinkedServicePropertyTypeValue] varchar(1000)
)
GO

CREATE TABLE [LinkedServiceType] (
  [LinkedServiceTypeId] int PRIMARY KEY IDENTITY(1, 1),
  [LinkedServiceTypeName] nvarchar(255) NOT NULL CHECK ([LinkedServiceTypeName] IN ('AzureSql', 'ADLS2', 'BlobContainer')) 
)
GO

CREATE TABLE [LinkedService] (
  [LinkedServiceId] int PRIMARY KEY NOT NULL IDENTITY(1, 1),
  [LinkedServiceName] varchar(100),
  [LinkedServiceTypeId] int,
  [LinkedServiceDescription] varchar(1000),
  [LinkedServiceParameter] varchar(1000),
  [LinkedServiceTags] varchar(1000),
  [IntegrationRuntimeId] int,
  [DataFactoryId] int,
  [LinkedServicePropertySetId] int
)
GO

CREATE TABLE [LinkedServiceProperty] (
  [LinkedServicePropertyId] int PRIMARY KEY NOT NULL IDENTITY(1, 1),
  [LinkedServiceId] int,
  [LinkedServicePropertyTypeId] int
)
GO

CREATE TABLE [LinkedServicePropertyConfig] (
  [LinkedServicePropertyConfigId] int PRIMARY KEY NOT NULL IDENTITY(1, 1),
  [LinkedServicePropertyId] int,
  [LinkedServicePropertySetId] int
)
GO

CREATE TABLE [LinkedServicePropertySet] (
  [LinkedServicePropertySetId] int PRIMARY KEY NOT NULL IDENTITY(1, 1),
  [LinkedServicePropertySet] int
)
GO

CREATE TABLE [LocationType] (
  [LocationTypeId] int PRIMARY KEY NOT NULL IDENTITY(1, 1),
  [LocationTypeName] nvarchar(255) NOT NULL CHECK ([LocationTypeName] IN ('Cloud', 'OnPrem'))
)
GO

CREATE TABLE [Location] (
  [LocationId] int PRIMARY KEY NOT NULL IDENTITY(1, 1),
  [LocationCode] varchar(20) NOT NULL,
  [LocationName] varchar(100) NOT NULL,
  [LocationTypeId] int
)
GO

CREATE TABLE [DataFlow] (
  [DataFlowId] int PRIMARY KEY NOT NULL IDENTITY(1, 1)
)
GO

CREATE TABLE [Dataset] (
  [DatasetId] int PRIMARY KEY NOT NULL IDENTITY(1, 1),
  [DatasetName] varchar(100) NOT NULL,
  [LinkedServiceId] int
)
GO

CREATE TABLE [DatasetParameter] (
  [DatasetParameterId] int PRIMARY KEY NOT NULL IDENTITY(1, 1),
  [DatasetParameterName] varchar(100) NOT NULL,
  [DatasetParameterType] nvarchar(255) NOT NULL CHECK ([DatasetParameterType] IN ('array', 'string', 'numeric', 'null', 'object', 'date', 'datetime', 'time')) ,
  [DatasetParameterDefault] varchar(100),
  [DatasetId] int
)
GO

CREATE TABLE [Pipeline] (
  [PipelineId] int PRIMARY KEY NOT NULL IDENTITY(1, 1)
)
GO

CREATE TABLE [Trigger] (
  [TriggerId] int PRIMARY KEY NOT NULL IDENTITY(1, 1)
)
GO

CREATE TABLE [Runs] (
  [RunId] int PRIMARY KEY NOT NULL IDENTITY(1, 1)
)
GO

CREATE TABLE [RunType] (
  [RunTypeId] int PRIMARY KEY NOT NULL IDENTITY(1, 1)
)
GO

CREATE TABLE [Activity] (
  [ActivityId] int PRIMARY KEY NOT NULL IDENTITY(1, 1)
)
GO

CREATE TABLE [Entity] (
  [EntityId] int PRIMARY KEY NOT NULL IDENTITY(1, 1),
  [EntityName] varchar(100),
  [EntityTypeId] int,
  [EntityPathId] int
)
GO

CREATE TABLE [EntityPath] (
  [EntityPathId] int PRIMARY KEY NOT NULL IDENTITY(1, 1),
  [EntityPathDefinition] varchar(100),
  [HostId] int
)
GO

CREATE TABLE [Host] (
  [HostId] int PRIMARY KEY NOT NULL IDENTITY(1, 1),
  [HostName] varchar(100),
  [CredentialType] int,
  [UserName] varchar(100),
  [Password] varchar(100)
)
GO

CREATE TABLE [EntityType] (
  [EntityTypeId] int PRIMARY KEY NOT NULL IDENTITY(1, 1),
  [EntityName] varchar(100)
)
GO

CREATE TABLE [Attribute] (
  [AttributeId] int PRIMARY KEY NOT NULL IDENTITY(1, 1),
  [AttributeName] varchar(100),
  [AttributeOrder] int,
  [AttributeType] varchar(50),
  [EntityId] int
)
GO



ALTER TABLE [LoadConfig] ADD FOREIGN KEY ([BusinessAreaId]) REFERENCES [BusinessArea] ([BusinessAreaId])
GO

ALTER TABLE [LoadConfig] ADD FOREIGN KEY ([LoadTypeId]) REFERENCES [LoadType] ([LoadTypeId])
GO

ALTER TABLE [LoadConfig] ADD FOREIGN KEY ([SourceDataFactoryId]) REFERENCES [DataFactory] ([DataFactoryId])
GO

ALTER TABLE [LoadConfig] ADD FOREIGN KEY ([SourceIntgrationRuntimeId]) REFERENCES [IntegrationRuntime] ([IntegrationRuntimeTypeId])
GO

ALTER TABLE [LoadConfig] ADD FOREIGN KEY ([SourceLinkedServiceId]) REFERENCES [LinkedService] ([LinkedServiceId])
GO

ALTER TABLE [LoadConfig] ADD FOREIGN KEY ([TargetDataFactoryId]) REFERENCES [DataFactory] ([DataFactoryId])
GO

ALTER TABLE [LoadConfig] ADD FOREIGN KEY ([TargetIntegrationRuntimeId]) REFERENCES [IntegrationRuntime] ([IntegrationRuntimeTypeId])
GO

ALTER TABLE [LoadConfig] ADD FOREIGN KEY ([TargetLinkedServiceId]) REFERENCES [LinkedService] ([LinkedServiceId])
GO

ALTER TABLE [Subscription] ADD FOREIGN KEY ([TennantId]) REFERENCES [Tennant] ([TennantId])
GO

ALTER TABLE [ResourceGroup] ADD FOREIGN KEY ([SubscriptionId]) REFERENCES [Subscription] ([SubscriptionId])
GO

ALTER TABLE [DataFactory] ADD FOREIGN KEY ([ResourceGroupId]) REFERENCES [ResourceGroup] ([ResourceGroupId])
GO

ALTER TABLE [IntegrationRuntime] ADD FOREIGN KEY ([IntegrationRuntimeTypeId]) REFERENCES [IntegrationRuntimeType] ([IntegrationRuntimeTypeId])
GO

ALTER TABLE [IntegrationRuntime] ADD FOREIGN KEY ([IntegrationRuntimeSubTypeId]) REFERENCES [IntegrationRuntimeSubType] ([IntegrationRuntimeSubTypeId])
GO

ALTER TABLE [IntegrationRuntime] ADD FOREIGN KEY ([DataFactoryId]) REFERENCES [DataFactory] ([DataFactoryId])
GO

ALTER TABLE [LinkedService] ADD FOREIGN KEY ([LinkedServiceTypeId]) REFERENCES [LinkedServiceType] ([LinkedServiceTypeId])
GO

ALTER TABLE [LinkedService] ADD FOREIGN KEY ([IntegrationRuntimeId]) REFERENCES [IntegrationRuntime] ([IntegrationRuntimeId])
GO

ALTER TABLE [LinkedService] ADD FOREIGN KEY ([DataFactoryId]) REFERENCES [DataFactory] ([DataFactoryId])
GO

ALTER TABLE [LinkedService] ADD FOREIGN KEY ([LinkedServicePropertySetId]) REFERENCES [DataFactory] ([DataFactoryId])
GO

ALTER TABLE [LinkedServiceProperty] ADD FOREIGN KEY ([LinkedServiceId]) REFERENCES [LinkedService] ([LinkedServiceId])
GO

ALTER TABLE [LinkedServiceProperty] ADD FOREIGN KEY ([LinkedServicePropertyTypeId]) REFERENCES [LinkedServicePropertyType] ([LinkedServicePropertyTypeId])
GO

ALTER TABLE [LinkedServicePropertyConfig] ADD FOREIGN KEY ([LinkedServicePropertyId]) REFERENCES [LinkedServiceProperty] ([LinkedServicePropertyId])
GO

ALTER TABLE [Location] ADD FOREIGN KEY ([LocationTypeId]) REFERENCES [LocationType] ([LocationTypeId])
GO

ALTER TABLE [Dataset] ADD FOREIGN KEY ([LinkedServiceId]) REFERENCES [LinkedService] ([LinkedServiceId])
GO

ALTER TABLE [DatasetParameter] ADD FOREIGN KEY ([DatasetId]) REFERENCES [Dataset] ([DatasetId])
GO

ALTER TABLE [LinkedService] ADD FOREIGN KEY ([LinkedServicePropertySetId]) REFERENCES [LinkedServicePropertySet] ([LinkedServicePropertySetId])
GO

ALTER TABLE [LinkedServicePropertyConfig] ADD FOREIGN KEY ([LinkedServicePropertySetId]) REFERENCES [LinkedServicePropertySet] ([LinkedServicePropertySetId])
GO

ALTER TABLE [ResourceGroup] ADD FOREIGN KEY ([ResourceGroupLocation]) REFERENCES [Location] ([LocationId])
GO

ALTER TABLE [DataFactory] ADD FOREIGN KEY ([DataFactoryLocation]) REFERENCES [Location] ([LocationId])
GO

ALTER TABLE [DeltaWatermark] ADD FOREIGN KEY ([DeltaWatermarkId]) REFERENCES [LoadConfig] ([DeltaWatermarkId])
GO

ALTER TABLE [Schedule] ADD FOREIGN KEY ([ScheduleId]) REFERENCES [LoadConfig] ([ScheduleId])
GO

ALTER TABLE [LoadConfig] ADD FOREIGN KEY ([ExecutionStatusTypeId]) REFERENCES [ExecutionStatusType] ([ExecutionStatusTypeId])
GO

ALTER TABLE [Entity] ADD FOREIGN KEY ([EntityTypeId]) REFERENCES [EntityType] ([EntityTypeId])
GO

ALTER TABLE [LoadConfig] ADD FOREIGN KEY ([SourceEntityId]) REFERENCES [Entity] ([EntityId])
GO

ALTER TABLE [LoadConfig] ADD FOREIGN KEY ([TargetEntityId]) REFERENCES [Entity] ([EntityId])
GO

ALTER TABLE [Attribute] ADD FOREIGN KEY ([EntityId]) REFERENCES [Entity] ([EntityTypeId])
GO

ALTER TABLE [Entity] ADD FOREIGN KEY ([EntityPathId]) REFERENCES [EntityPath] ([EntityPathId])
GO

ALTER TABLE [EntityPath] ADD FOREIGN KEY ([HostId]) REFERENCES [Host] ([HostId])
GO



EXEC SpExecConfig;
USE [master]
GO
/****** Object:  Database [sdbamsdapdev001]    Script Date: 15/05/2018 09:43:05 ******/
CREATE DATABASE [sdbamsdapdev001]
GO
ALTER DATABASE [sdbamsdapdev001] SET COMPATIBILITY_LEVEL = 140
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [sdbamsdapdev001].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [sdbamsdapdev001] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [sdbamsdapdev001] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [sdbamsdapdev001] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [sdbamsdapdev001] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [sdbamsdapdev001] SET ARITHABORT OFF 
GO
ALTER DATABASE [sdbamsdapdev001] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [sdbamsdapdev001] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [sdbamsdapdev001] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [sdbamsdapdev001] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [sdbamsdapdev001] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [sdbamsdapdev001] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [sdbamsdapdev001] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [sdbamsdapdev001] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [sdbamsdapdev001] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [sdbamsdapdev001] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [sdbamsdapdev001] SET ALLOW_SNAPSHOT_ISOLATION ON 
GO
ALTER DATABASE [sdbamsdapdev001] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [sdbamsdapdev001] SET READ_COMMITTED_SNAPSHOT ON 
GO
ALTER DATABASE [sdbamsdapdev001] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [sdbamsdapdev001] SET  MULTI_USER 
GO
ALTER DATABASE [sdbamsdapdev001] SET DB_CHAINING OFF 
GO
ALTER DATABASE [sdbamsdapdev001] SET ENCRYPTION ON
GO
ALTER DATABASE [sdbamsdapdev001] SET QUERY_STORE = ON
GO
ALTER DATABASE [sdbamsdapdev001] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 100, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO)
GO
USE [sdbamsdapdev001]
GO
ALTER DATABASE SCOPED CONFIGURATION SET ELEVATE_ONLINE = OFF TargetReplic;
GO
ALTER DATABASE SCOPED CONFIGURATION SET ELEVATE_RESUMABLE = OFF TargetReplic;
GO
ALTER DATABASE SCOPED CONFIGURATION SET IDENTITY_CACHE = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION SET ISOLATE_SECURITY_POLICY_CARDINALITY = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET OPTIMIZE_FOR_AD_HOC_WORKLOADS = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET XTP_PROCEDURE_EXECUTION_STATISTICS = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION SET XTP_QUERY_EXECUTION_STATISTICS = OFF;
GO
USE [sdbamsdapdev001]
GO
/****** Object:  Schema [metadata]    Script Date: 15/05/2018 09:43:08 ******/
CREATE SCHEMA [metadata]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_diagramobjects]    Script Date: 15/05/2018 09:43:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	CREATE FUNCTION [dbo].[fn_diagramobjects]() 
	RETURNS int
	WITH EXECUTE AS N'dbo'
	AS
	BEGIN
		declare @id_upgraddiagrams		int
		declare @id_sysdiagrams			int
		declare @id_helpdiagrams		int
		declare @id_helpdiagramdefinition	int
		declare @id_creatediagram	int
		declare @id_renamediagram	int
		declare @id_alterdiagram 	int 
		declare @id_dropdiagram		int
		declare @InstalledObjects	int

		select @InstalledObjects = 0

		select 	@id_upgraddiagrams = object_id(N'dbo.sp_upgraddiagrams'),
			@id_sysdiagrams = object_id(N'dbo.sysdiagrams'),
			@id_helpdiagrams = object_id(N'dbo.sp_helpdiagrams'),
			@id_helpdiagramdefinition = object_id(N'dbo.sp_helpdiagramdefinition'),
			@id_creatediagram = object_id(N'dbo.sp_creatediagram'),
			@id_renamediagram = object_id(N'dbo.sp_renamediagram'),
			@id_alterdiagram = object_id(N'dbo.sp_alterdiagram'), 
			@id_dropdiagram = object_id(N'dbo.sp_dropdiagram')

		if @id_upgraddiagrams is not null
			select @InstalledObjects = @InstalledObjects + 1
		if @id_sysdiagrams is not null
			select @InstalledObjects = @InstalledObjects + 2
		if @id_helpdiagrams is not null
			select @InstalledObjects = @InstalledObjects + 4
		if @id_helpdiagramdefinition is not null
			select @InstalledObjects = @InstalledObjects + 8
		if @id_creatediagram is not null
			select @InstalledObjects = @InstalledObjects + 16
		if @id_renamediagram is not null
			select @InstalledObjects = @InstalledObjects + 32
		if @id_alterdiagram  is not null
			select @InstalledObjects = @InstalledObjects + 64
		if @id_dropdiagram is not null
			select @InstalledObjects = @InstalledObjects + 128
		
		return @InstalledObjects 
	END
	
GO
/****** Object:  UserDefinedFunction [dbo].[GetProperty]    Script Date: 15/05/2018 09:43:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[GetProperty]
	(
	@PropertyName VARCHAR(128)
	)
RETURNS VARCHAR(500)
AS
BEGIN
	DECLARE @Value VARCHAR(500)

	SELECT
		@Value = [PropertyValue]
	FROM
		[dbo].[TransformProperties]
	WHERE
		[PropertyName] = @PropertyName

	RETURN @Value
END
GO
/****** Object:  UserDefinedFunction [metadata].[RemoveEndChar]    Script Date: 15/05/2018 09:43:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [metadata].[RemoveEndChar]
(
	@RawString NVARCHAR(MAX)
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE @CleanString NVARCHAR(MAX)
	
	SET @CleanString = SUBSTRING(@RawString,0,LEN(@RawString) - 1)

    RETURN @CleanString
END
GO
/****** Object:  UserDefinedFunction [metadata].[RemoveLastComma]    Script Date: 15/05/2018 09:43:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [metadata].[RemoveLastComma]
(
	@RawString NVARCHAR(MAX)
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE @CleanString NVARCHAR(MAX)
	
	--white space friendly
	SET @CleanString = REVERSE(SUBSTRING(REVERSE(@RawString),CHARINDEX(',',REVERSE(@RawString))+1,LEN(@RawString)))

    RETURN @CleanString
END
GO
/****** Object:  UserDefinedFunction [metadata].[UpperCaseFirstChar]    Script Date: 15/05/2018 09:43:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [metadata].[UpperCaseFirstChar]
(
	@RawString NVARCHAR(MAX)
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE @CleanString NVARCHAR(MAX)
	
	SET @CleanString =  UPPER(LEFT(@RawString, 1)) + LOWER(RIGHT(@RawString, LEN(@RawString) - 1))

    RETURN @CleanString
END
GO
/****** Object:  Table [metadata].[Mappings]    Script Date: 15/05/2018 09:43:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [metadata].[Mappings](
	[MappingId] [int] IDENTITY(1,1) NOT NULL,
	[DataFlowId] [int] NOT NULL,
	[SourceSystemId] [int] NOT NULL,
	[SourceObjectId] [int] NOT NULL,
	[SourceAttributeId] [int] NOT NULL,
	[TargetSystemId] [int] NOT NULL,
	[TargetObjectId] [int] NOT NULL,
	[TargetAttributeId] [int] NOT NULL,
	[InUse] [bit] NOT NULL,
 CONSTRAINT [PK_Mappings] PRIMARY KEY CLUSTERED 
(
	[MappingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [metadata].[Objects]    Script Date: 15/05/2018 09:43:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [metadata].[Objects](
	[ObjectId] [int] IDENTITY(1,1) NOT NULL,
	[ObjectTypeId] [int] NOT NULL,
	[ObjectPrefix] [varchar](128) NULL,
	[ObjectName] [varchar](128) NOT NULL,
	[SystemId] [int] NOT NULL,
	[ObjectAdditions] [nvarchar](500) NULL,
	[InUse] [bit] NOT NULL,
 CONSTRAINT [PK_Objects] PRIMARY KEY CLUSTERED 
(
	[ObjectId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [metadata].[DataFlows]    Script Date: 15/05/2018 09:43:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [metadata].[DataFlows](
	[DataFlowId] [int] IDENTITY(1,1) NOT NULL,
	[DataFlowName] [varchar](255) NOT NULL,
	[ScriptId] [int] NULL,
	[InUse] [bit] NOT NULL,
 CONSTRAINT [PK_DataFlows] PRIMARY KEY CLUSTERED 
(
	[DataFlowId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [metadata].[Attributes]    Script Date: 15/05/2018 09:43:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [metadata].[Attributes](
	[AttributeId] [int] IDENTITY(1,1) NOT NULL,
	[AttributeName] [varchar](128) NOT NULL,
	[DataType] [varchar](128) NULL,
	[IsPK] [bit] NULL,
	[ObjectId] [int] NOT NULL,
 CONSTRAINT [PK_Attributes] PRIMARY KEY CLUSTERED 
(
	[AttributeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [metadata].[Systems]    Script Date: 15/05/2018 09:43:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [metadata].[Systems](
	[SystemId] [int] IDENTITY(1,1) NOT NULL,
	[SystemName] [varchar](255) NOT NULL,
	[SystemTechnologyId] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Systems_1] PRIMARY KEY CLUSTERED 
(
	[SystemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [metadata].[SystemTechnologies]    Script Date: 15/05/2018 09:43:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [metadata].[SystemTechnologies](
	[SystemTechId] [int] IDENTITY(1,1) NOT NULL,
	[TechnologyName] [varchar](50) NOT NULL,
 CONSTRAINT [PK_SystemTechnologies] PRIMARY KEY CLUSTERED 
(
	[SystemTechId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [metadata].[ObjectTypes]    Script Date: 15/05/2018 09:43:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [metadata].[ObjectTypes](
	[ObjectTypeId] [int] IDENTITY(1,1) NOT NULL,
	[ObjectTypeName] [varchar](128) NOT NULL,
 CONSTRAINT [PK_ObjectTypes] PRIMARY KEY CLUSTERED 
(
	[ObjectTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [metadata].[CompleteMappings]    Script Date: 15/05/2018 09:43:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [metadata].[CompleteMappings]
AS

SELECT
	m.[MappingId],
	df.[DataFlowName],
	sst.[TechnologyName] AS 'SourceSystemTechnology',
	ss.[SystemName] AS 'SourceSystem',
	tst.[TechnologyName] AS 'TargetSystemTechnology',
	ts.[SystemName] AS 'TargetSystem',
	so.[ObjectPrefix] AS 'SourceObjectPrefix',
	sot.[ObjectTypeName] AS 'SourceObjectType',
	so.[ObjectName] AS 'SourceObject',
	tro.[ObjectPrefix] AS 'TargetObjectPrefix',
	tot.[ObjectTypeName] AS 'TargetObjectType',
	tro.[ObjectName] AS 'TargetObject',
	sa.[AttributeName] AS 'SourceAttribute',
	sa.[IsPK] AS 'SourcePrimaryKey',
	sa.[DataType] AS 'SourceDataType',
	ta.[AttributeName] AS 'TargetAttribute',
	ta.[DataType] AS 'TargetDataType',
	ta.[IsPK] AS 'TargetPrimaryKey'
FROM
	[metadata].[Mappings] m
	INNER JOIN [metadata].[DataFlows] df
		ON m.[DataFlowId] = df.[DataFlowId]
	INNER JOIN [metadata].[Systems] ss
		ON m.[SourceSystemId] = ss.[SystemId]
	INNER JOIN [metadata].[SystemTechnologies] sst
		ON ss.[SystemTechnologyId] = sst.[SystemTechId]
	INNER JOIN [metadata].[Systems] ts
		ON m.[TargetSystemId] = ts.[SystemId]
	INNER JOIN [metadata].[SystemTechnologies] tst
		ON ts.[SystemTechnologyId] = tst.[SystemTechId]
	INNER JOIN [metadata].[Objects] so
		ON m.[SourceObjectId] = so.[ObjectId]
	INNER JOIN [metadata].[ObjectTypes] sot
		ON so.[ObjectTypeId] = sot.[ObjectTypeId]
	INNER JOIN [metadata].[Objects] tro
		ON m.[TargetObjectId] = tro.[ObjectId]
	INNER JOIN [metadata].[ObjectTypes] tot
		ON tro.[ObjectTypeId] = tot.[ObjectTypeId]
	INNER JOIN [metadata].[Attributes] sa
		ON m.[SourceAttributeId] = sa.[AttributeId]
	INNER JOIN [metadata].[Attributes] ta
		ON m.[TargetAttributeId] = ta.[AttributeId]
GO
/****** Object:  View [metadata].[SourceObjects]    Script Date: 15/05/2018 09:43:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [metadata].[SourceObjects]
AS

SELECT DISTINCT
	df.[DataFlowName],
	sot.[ObjectTypeName] AS 'SourceObjectType',
	so.[ObjectPrefix] AS 'SourcePrefix',
	so.[ObjectName] AS 'SourceObject',
	so.[ObjectAdditions] AS 'SourceObjectAdditions'
FROM
	[metadata].[Mappings] m
	INNER JOIN [metadata].[DataFlows] df
		ON m.[DataFlowId] = df.[DataFlowId]
	INNER JOIN [metadata].[Objects] so
		ON m.[SourceObjectId] = so.[ObjectId]
	INNER JOIN [metadata].[ObjectTypes] sot
		ON so.[ObjectTypeId] = sot.[ObjectTypeId]
GO
/****** Object:  View [metadata].[TargetObjects]    Script Date: 15/05/2018 09:43:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [metadata].[TargetObjects]
AS

SELECT DISTINCT
	df.[DataFlowName],
	sot.[ObjectTypeName] AS 'TargetObjectType',
	so.[ObjectPrefix] AS 'TargetPrefix',
	so.[ObjectName] AS 'TargetObject',
	so.[ObjectAdditions] AS 'TargetObjectAdditions'
FROM
	[metadata].[Mappings] m
	INNER JOIN [metadata].[DataFlows] df
		ON m.[DataFlowId] = df.[DataFlowId]
	INNER JOIN [metadata].[Objects] so
		ON m.[TargetObjectId] = so.[ObjectId]
	INNER JOIN [metadata].[ObjectTypes] sot
		ON so.[ObjectTypeId] = sot.[ObjectTypeId]
GO
/****** Object:  View [metadata].[SourceFiles]    Script Date: 15/05/2018 09:43:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [metadata].[SourceFiles]
AS

SELECT
	o.[ObjectId] AS 'Id',
	o.[ObjectName] + '.' + ot.[ObjectTypeName] AS 'FileName',
	'ADFRoot\ForUpload\' + o.[ObjectPrefix] AS 'SourceFolder',
	'ADFDemo\Uploads\' + s.[SystemName] AS 'TargetFolder'
FROM
	[metadata].[Objects] o
	INNER JOIN [metadata].[Systems] s
		ON o.[SystemId] = s.[SystemId]
	INNER JOIN [metadata].[SystemTechnologies] st
		ON s.[SystemTechnologyId] = st.[SystemTechId]
	INNER JOIN [metadata].[ObjectTypes] ot
		ON o.[ObjectTypeId] = ot.[ObjectTypeId]
WHERE
	st.[TechnologyName] = 'File'
	AND s.[SystemName] = 'DemoSystem'
	AND o.[InUse] = 1

GO
/****** Object:  Table [dbo].[LoadingLog]    Script Date: 15/05/2018 09:43:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LoadingLog](
	[LogId] [int] IDENTITY(1,1) NOT NULL,
	[ObjectId] [int] NOT NULL,
	[Status] [varchar](128) NULL,
	[LogDate] [datetime] NOT NULL,
 CONSTRAINT [PK_LoadingLog] PRIMARY KEY CLUSTERED 
(
	[LogId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[Log]    Script Date: 15/05/2018 09:43:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Log]
AS


SELECT
	ll.[LogId],
	o.[ObjectName],
	ll.[Status],
	ll.[LogDate]
 FROM 
	[dbo].[LoadingLog] ll
	INNER JOIN [metadata].[Objects] o
		ON ll.[ObjectId] = o.[ObjectId]
GO
/****** Object:  Table [dbo].[sysdiagrams]    Script Date: 15/05/2018 09:43:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sysdiagrams](
	[name] [sysname] NOT NULL,
	[principal_id] [int] NOT NULL,
	[diagram_id] [int] IDENTITY(1,1) NOT NULL,
	[version] [int] NULL,
	[definition] [varbinary](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[diagram_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UK_principal_name] UNIQUE NONCLUSTERED 
(
	[principal_id] ASC,
	[name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TransformProperties]    Script Date: 15/05/2018 09:43:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TransformProperties](
	[PropertyId] [int] IDENTITY(1,1) NOT NULL,
	[PropertyName] [varchar](128) NOT NULL,
	[PropertyValue] [varchar](500) NULL,
	[PropertyDescription] [varchar](max) NULL,
 CONSTRAINT [PK_TransformProperties] PRIMARY KEY CLUSTERED 
(
	[PropertyName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [metadata].[ScriptParts]    Script Date: 15/05/2018 09:43:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [metadata].[ScriptParts](
	[ScriptId] [int] IDENTITY(1,1) NOT NULL,
	[ScriptName] [varchar](128) NOT NULL,
	[Script] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_ScriptParts] PRIMARY KEY CLUSTERED 
(
	[ScriptId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [nonclusidx_DataFlowName]    Script Date: 15/05/2018 09:43:10 ******/
CREATE NONCLUSTERED INDEX [nonclusidx_DataFlowName] ON [metadata].[DataFlows]
(
	[DataFlowName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LoadingLog] ADD  CONSTRAINT [DF_LoadingLog_LogDate]  DEFAULT (getdate()) FOR [LogDate]
GO
ALTER TABLE [metadata].[Mappings] ADD  CONSTRAINT [DF_Mappings_InUse]  DEFAULT ((1)) FOR [InUse]
GO
ALTER TABLE [metadata].[Objects] ADD  CONSTRAINT [DF_Objects_InUse]  DEFAULT ((1)) FOR [InUse]
GO
ALTER TABLE [metadata].[Systems] ADD  CONSTRAINT [DF_Systems_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [metadata].[Attributes]  WITH CHECK ADD  CONSTRAINT [FK_Attributes_Objects] FOREIGN KEY([ObjectId])
REFERENCES [metadata].[Objects] ([ObjectId])
GO
ALTER TABLE [metadata].[Attributes] CHECK CONSTRAINT [FK_Attributes_Objects]
GO
ALTER TABLE [metadata].[DataFlows]  WITH CHECK ADD  CONSTRAINT [FK_DataFlows_ScriptParts] FOREIGN KEY([ScriptId])
REFERENCES [metadata].[ScriptParts] ([ScriptId])
GO
ALTER TABLE [metadata].[DataFlows] CHECK CONSTRAINT [FK_DataFlows_ScriptParts]
GO
ALTER TABLE [metadata].[Mappings]  WITH CHECK ADD  CONSTRAINT [FK_Mappings_Attributes_Source] FOREIGN KEY([SourceAttributeId])
REFERENCES [metadata].[Attributes] ([AttributeId])
GO
ALTER TABLE [metadata].[Mappings] CHECK CONSTRAINT [FK_Mappings_Attributes_Source]
GO
ALTER TABLE [metadata].[Mappings]  WITH CHECK ADD  CONSTRAINT [FK_Mappings_Attributes_Target] FOREIGN KEY([TargetAttributeId])
REFERENCES [metadata].[Attributes] ([AttributeId])
GO
ALTER TABLE [metadata].[Mappings] CHECK CONSTRAINT [FK_Mappings_Attributes_Target]
GO
ALTER TABLE [metadata].[Mappings]  WITH CHECK ADD  CONSTRAINT [FK_Mappings_DataFlows] FOREIGN KEY([DataFlowId])
REFERENCES [metadata].[DataFlows] ([DataFlowId])
GO
ALTER TABLE [metadata].[Mappings] CHECK CONSTRAINT [FK_Mappings_DataFlows]
GO
ALTER TABLE [metadata].[Mappings]  WITH CHECK ADD  CONSTRAINT [FK_Mappings_Objects_Source] FOREIGN KEY([SourceObjectId])
REFERENCES [metadata].[Objects] ([ObjectId])
GO
ALTER TABLE [metadata].[Mappings] CHECK CONSTRAINT [FK_Mappings_Objects_Source]
GO
ALTER TABLE [metadata].[Mappings]  WITH CHECK ADD  CONSTRAINT [FK_Mappings_Objects_Target] FOREIGN KEY([TargetObjectId])
REFERENCES [metadata].[Objects] ([ObjectId])
GO
ALTER TABLE [metadata].[Mappings] CHECK CONSTRAINT [FK_Mappings_Objects_Target]
GO
ALTER TABLE [metadata].[Mappings]  WITH CHECK ADD  CONSTRAINT [FK_Mappings_Systems_Source] FOREIGN KEY([SourceSystemId])
REFERENCES [metadata].[Systems] ([SystemId])
GO
ALTER TABLE [metadata].[Mappings] CHECK CONSTRAINT [FK_Mappings_Systems_Source]
GO
ALTER TABLE [metadata].[Mappings]  WITH CHECK ADD  CONSTRAINT [FK_Mappings_Systems_Target] FOREIGN KEY([TargetSystemId])
REFERENCES [metadata].[Systems] ([SystemId])
GO
ALTER TABLE [metadata].[Mappings] CHECK CONSTRAINT [FK_Mappings_Systems_Target]
GO
ALTER TABLE [metadata].[Objects]  WITH CHECK ADD  CONSTRAINT [FK_Objects_ObjectTypes] FOREIGN KEY([ObjectTypeId])
REFERENCES [metadata].[ObjectTypes] ([ObjectTypeId])
GO
ALTER TABLE [metadata].[Objects] CHECK CONSTRAINT [FK_Objects_ObjectTypes]
GO
ALTER TABLE [metadata].[Systems]  WITH CHECK ADD  CONSTRAINT [FK_Systems_SystemTechnologies] FOREIGN KEY([SystemTechnologyId])
REFERENCES [metadata].[SystemTechnologies] ([SystemTechId])
GO
ALTER TABLE [metadata].[Systems] CHECK CONSTRAINT [FK_Systems_SystemTechnologies]
GO
/****** Object:  StoredProcedure [dbo].[CreateLogEntry]    Script Date: 15/05/2018 09:43:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CreateLogEntry]
	(
	@ObjectId INT,
	@Status VARCHAR(128)
	)
AS

BEGIN

	INSERT INTO	[dbo].[LoadingLog]
		(
		[ObjectId],
		[Status]
		)
	VALUES
		(
		@ObjectId,
		@Status
		)

END
GO
/****** Object:  StoredProcedure [dbo].[sp_alterdiagram]    Script Date: 15/05/2018 09:43:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	CREATE PROCEDURE [dbo].[sp_alterdiagram]
	(
		@diagramname 	sysname,
		@owner_id	int	= null,
		@version 	int,
		@definition 	varbinary(max)
	)
	WITH EXECUTE AS 'dbo'
	AS
	BEGIN
		set nocount on
	
		declare @theId 			int
		declare @retval 		int
		declare @IsDbo 			int
		
		declare @UIDFound 		int
		declare @DiagId			int
		declare @ShouldChangeUID	int
	
		if(@diagramname is null)
		begin
			RAISERROR ('Invalid ARG', 16, 1)
			return -1
		end
	
		execute as caller;
		select @theId = DATABASE_PRINCIPAL_ID();	 
		select @IsDbo = IS_MEMBER(N'db_owner'); 
		if(@owner_id is null)
			select @owner_id = @theId;
		revert;
	
		select @ShouldChangeUID = 0
		select @DiagId = diagram_id, @UIDFound = principal_id from dbo.sysdiagrams where principal_id = @owner_id and name = @diagramname 
		
		if(@DiagId IS NULL or (@IsDbo = 0 and @theId <> @UIDFound))
		begin
			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1);
			return -3
		end
	
		if(@IsDbo <> 0)
		begin
			if(@UIDFound is null or USER_NAME(@UIDFound) is null) -- invalid principal_id
			begin
				select @ShouldChangeUID = 1 ;
			end
		end

		-- update dds data			
		update dbo.sysdiagrams set definition = @definition where diagram_id = @DiagId ;

		-- change owner
		if(@ShouldChangeUID = 1)
			update dbo.sysdiagrams set principal_id = @theId where diagram_id = @DiagId ;

		-- update dds version
		if(@version is not null)
			update dbo.sysdiagrams set version = @version where diagram_id = @DiagId ;

		return 0
	END
	
GO
/****** Object:  StoredProcedure [dbo].[sp_creatediagram]    Script Date: 15/05/2018 09:43:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	CREATE PROCEDURE [dbo].[sp_creatediagram]
	(
		@diagramname 	sysname,
		@owner_id		int	= null, 	
		@version 		int,
		@definition 	varbinary(max)
	)
	WITH EXECUTE AS 'dbo'
	AS
	BEGIN
		set nocount on
	
		declare @theId int
		declare @retval int
		declare @IsDbo	int
		declare @userName sysname
		if(@version is null or @diagramname is null)
		begin
			RAISERROR (N'E_INVALIDARG', 16, 1);
			return -1
		end
	
		execute as caller;
		select @theId = DATABASE_PRINCIPAL_ID(); 
		select @IsDbo = IS_MEMBER(N'db_owner');
		revert; 
		
		if @owner_id is null
		begin
			select @owner_id = @theId;
		end
		else
		begin
			if @theId <> @owner_id
			begin
				if @IsDbo = 0
				begin
					RAISERROR (N'E_INVALIDARG', 16, 1);
					return -1
				end
				select @theId = @owner_id
			end
		end
		-- next 2 line only for test, will be removed after define name unique
		if EXISTS(select diagram_id from dbo.sysdiagrams where principal_id = @theId and name = @diagramname)
		begin
			RAISERROR ('The name is already used.', 16, 1);
			return -2
		end
	
		insert into dbo.sysdiagrams(name, principal_id , version, definition)
				VALUES(@diagramname, @theId, @version, @definition) ;
		
		select @retval = @@IDENTITY 
		return @retval
	END
	
GO
/****** Object:  StoredProcedure [dbo].[sp_dropdiagram]    Script Date: 15/05/2018 09:43:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	CREATE PROCEDURE [dbo].[sp_dropdiagram]
	(
		@diagramname 	sysname,
		@owner_id	int	= null
	)
	WITH EXECUTE AS 'dbo'
	AS
	BEGIN
		set nocount on
		declare @theId 			int
		declare @IsDbo 			int
		
		declare @UIDFound 		int
		declare @DiagId			int
	
		if(@diagramname is null)
		begin
			RAISERROR ('Invalid value', 16, 1);
			return -1
		end
	
		EXECUTE AS CALLER;
		select @theId = DATABASE_PRINCIPAL_ID();
		select @IsDbo = IS_MEMBER(N'db_owner'); 
		if(@owner_id is null)
			select @owner_id = @theId;
		REVERT; 
		
		select @DiagId = diagram_id, @UIDFound = principal_id from dbo.sysdiagrams where principal_id = @owner_id and name = @diagramname 
		if(@DiagId IS NULL or (@IsDbo = 0 and @UIDFound <> @theId))
		begin
			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1)
			return -3
		end
	
		delete from dbo.sysdiagrams where diagram_id = @DiagId;
	
		return 0;
	END
	
GO
/****** Object:  StoredProcedure [dbo].[sp_helpdiagramdefinition]    Script Date: 15/05/2018 09:43:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	CREATE PROCEDURE [dbo].[sp_helpdiagramdefinition]
	(
		@diagramname 	sysname,
		@owner_id	int	= null 		
	)
	WITH EXECUTE AS N'dbo'
	AS
	BEGIN
		set nocount on

		declare @theId 		int
		declare @IsDbo 		int
		declare @DiagId		int
		declare @UIDFound	int
	
		if(@diagramname is null)
		begin
			RAISERROR (N'E_INVALIDARG', 16, 1);
			return -1
		end
	
		execute as caller;
		select @theId = DATABASE_PRINCIPAL_ID();
		select @IsDbo = IS_MEMBER(N'db_owner');
		if(@owner_id is null)
			select @owner_id = @theId;
		revert; 
	
		select @DiagId = diagram_id, @UIDFound = principal_id from dbo.sysdiagrams where principal_id = @owner_id and name = @diagramname;
		if(@DiagId IS NULL or (@IsDbo = 0 and @UIDFound <> @theId ))
		begin
			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1);
			return -3
		end

		select version, definition FROM dbo.sysdiagrams where diagram_id = @DiagId ; 
		return 0
	END
	
GO
/****** Object:  StoredProcedure [dbo].[sp_helpdiagrams]    Script Date: 15/05/2018 09:43:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	CREATE PROCEDURE [dbo].[sp_helpdiagrams]
	(
		@diagramname sysname = NULL,
		@owner_id int = NULL
	)
	WITH EXECUTE AS N'dbo'
	AS
	BEGIN
		DECLARE @user sysname
		DECLARE @dboLogin bit
		EXECUTE AS CALLER;
			SET @user = USER_NAME();
			SET @dboLogin = CONVERT(bit,IS_MEMBER('db_owner'));
		REVERT;
		SELECT
			[Database] = DB_NAME(),
			[Name] = name,
			[ID] = diagram_id,
			[Owner] = USER_NAME(principal_id),
			[OwnerID] = principal_id
		FROM
			sysdiagrams
		WHERE
			(@dboLogin = 1 OR USER_NAME(principal_id) = @user) AND
			(@diagramname IS NULL OR name = @diagramname) AND
			(@owner_id IS NULL OR principal_id = @owner_id)
		ORDER BY
			4, 5, 1
	END
	
GO
/****** Object:  StoredProcedure [dbo].[sp_renamediagram]    Script Date: 15/05/2018 09:43:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	CREATE PROCEDURE [dbo].[sp_renamediagram]
	(
		@diagramname 		sysname,
		@owner_id		int	= null,
		@new_diagramname	sysname
	
	)
	WITH EXECUTE AS 'dbo'
	AS
	BEGIN
		set nocount on
		declare @theId 			int
		declare @IsDbo 			int
		
		declare @UIDFound 		int
		declare @DiagId			int
		declare @DiagIdTarg		int
		declare @u_name			sysname
		if((@diagramname is null) or (@new_diagramname is null))
		begin
			RAISERROR ('Invalid value', 16, 1);
			return -1
		end
	
		EXECUTE AS CALLER;
		select @theId = DATABASE_PRINCIPAL_ID();
		select @IsDbo = IS_MEMBER(N'db_owner'); 
		if(@owner_id is null)
			select @owner_id = @theId;
		REVERT;
	
		select @u_name = USER_NAME(@owner_id)
	
		select @DiagId = diagram_id, @UIDFound = principal_id from dbo.sysdiagrams where principal_id = @owner_id and name = @diagramname 
		if(@DiagId IS NULL or (@IsDbo = 0 and @UIDFound <> @theId))
		begin
			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1)
			return -3
		end
	
		-- if((@u_name is not null) and (@new_diagramname = @diagramname))	-- nothing will change
		--	return 0;
	
		if(@u_name is null)
			select @DiagIdTarg = diagram_id from dbo.sysdiagrams where principal_id = @theId and name = @new_diagramname
		else
			select @DiagIdTarg = diagram_id from dbo.sysdiagrams where principal_id = @owner_id and name = @new_diagramname
	
		if((@DiagIdTarg is not null) and  @DiagId <> @DiagIdTarg)
		begin
			RAISERROR ('The name is already used.', 16, 1);
			return -2
		end		
	
		if(@u_name is null)
			update dbo.sysdiagrams set [name] = @new_diagramname, principal_id = @theId where diagram_id = @DiagId
		else
			update dbo.sysdiagrams set [name] = @new_diagramname where diagram_id = @DiagId
		return 0
	END
	
GO
/****** Object:  StoredProcedure [dbo].[sp_upgraddiagrams]    Script Date: 15/05/2018 09:43:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	CREATE PROCEDURE [dbo].[sp_upgraddiagrams]
	AS
	BEGIN
		IF OBJECT_ID(N'dbo.sysdiagrams') IS NOT NULL
			return 0;
	
		CREATE TABLE dbo.sysdiagrams
		(
			name sysname NOT NULL,
			principal_id int NOT NULL,	-- we may change it to varbinary(85)
			diagram_id int PRIMARY KEY IDENTITY,
			version int,
	
			definition varbinary(max)
			CONSTRAINT UK_principal_name UNIQUE
			(
				principal_id,
				name
			)
		);


		/* Add this if we need to have some form of extended properties for diagrams */
		/*
		IF OBJECT_ID(N'dbo.sysdiagram_properties') IS NULL
		BEGIN
			CREATE TABLE dbo.sysdiagram_properties
			(
				diagram_id int,
				name sysname,
				value varbinary(max) NOT NULL
			)
		END
		*/

		IF OBJECT_ID(N'dbo.dtproperties') IS NOT NULL
		begin
			insert into dbo.sysdiagrams
			(
				[name],
				[principal_id],
				[version],
				[definition]
			)
			select	 
				convert(sysname, dgnm.[uvalue]),
				DATABASE_PRINCIPAL_ID(N'dbo'),			-- will change to the sid of sa
				0,							-- zero for old format, dgdef.[version],
				dgdef.[lvalue]
			from dbo.[dtproperties] dgnm
				inner join dbo.[dtproperties] dggd on dggd.[property] = 'DtgSchemaGUID' and dggd.[objectid] = dgnm.[objectid]	
				inner join dbo.[dtproperties] dgdef on dgdef.[property] = 'DtgSchemaDATA' and dgdef.[objectid] = dgnm.[objectid]
				
			where dgnm.[property] = 'DtgSchemaNAME' and dggd.[uvalue] like N'_EA3E6268-D998-11CE-9454-00AA00A3F36E_' 
			return 2;
		end
		return 1;
	END
	
GO
/****** Object:  StoredProcedure [dbo].[usp_PrintBig]    Script Date: 15/05/2018 09:43:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_PrintBig] (
   @text NVARCHAR(MAX)
 )
AS
 
--DECLARE @text NVARCHAR(MAX) = 'YourTextHere'
DECLARE @lineSep NVARCHAR(2) = CHAR(13) + CHAR(10)  -- Windows \r\n
 
DECLARE @off INT = 1
DECLARE @maxLen INT = 4000
DECLARE @len INT
 
WHILE @off < LEN(@text)
BEGIN
 
  SELECT @len =
    CASE
      WHEN LEN(@text) - @off - 1 <= @maxLen THEN LEN(@text)
      ELSE @maxLen
             - CHARINDEX(REVERSE(@lineSep),  REVERSE(SUBSTRING(@text, @off, @maxLen)))
             - LEN(@lineSep)
             + 1
    END
  PRINT SUBSTRING(@text, @off, @len)
  --PRINT '@off=' + CAST(@off AS VARCHAR) + ' @len=' + CAST(@len AS VARCHAR)
  SET @off += @len + LEN(@lineSep)
 
END
GO
/****** Object:  StoredProcedure [metadata].[AddNewMapping]    Script Date: 15/05/2018 09:43:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [metadata].[AddNewMapping]
	(
	@DataFlowName VARCHAR(255),
	@SourceSystem VARCHAR(255),
	@TargetSystem VARCHAR(255),
	@SourceObjectPrefix VARCHAR(128),
	@SourceObject VARCHAR(128),
	@TargetObjectPrefix VARCHAR(128),
	@TargetObject VARCHAR(128),
	@SourceAttribute VARCHAR(128),
	@SourceDataType VARCHAR(128),
	@TargetAttribute VARCHAR(128),
	@TargetDataType VARCHAR(128),
	@Override BIT = 1
	)
AS

SET NOCOUNT ON;

BEGIN

	DECLARE @NewDataFlow INT
	DECLARE @NewSourceSystem INT
	DECLARE @NewTargetSystem INT
	DECLARE @NewSourceObject INT
	DECLARE @NewTargetObject INT
	DECLARE @NewSourceAttribute INT
	DECLARE @NewTargetAttribute INT
	DECLARE @NewMapping INT

	--defensive checks
	IF EXISTS
		(
		SELECT
			*
		FROM
			[metadata].[CompleteMappings]
		WHERE
			[DataFlowName] = @DataFlowName
			AND [SourceSystem] = @SourceSystem
			AND [TargetSystem] = @TargetSystem
			AND [SourceObjectPrefix] = @SourceObjectPrefix
			AND [SourceObject] = @SourceObject
			AND [TargetObjectPrefix] = @TargetObjectPrefix
			AND [TargetObject] = @TargetObject
			AND [SourceAttribute] = @SourceAttribute
			AND [SourceDataType] = @SourceDataType
			AND [TargetAttribute] = @TargetAttribute
			AND [TargetDataType] = @TargetDataType
		)
		BEGIN
			RAISERROR('This exact mapping already exists. Returning.',16,1)
			RETURN;
		END

	---------------------------------------------------------------------------------------------
	--									data flow
	---------------------------------------------------------------------------------------------
	IF NOT EXISTS
		(
		SELECT * FROM [metadata].[DataFlows] WHERE [DataFlowName] = @DataFlowName
		)
		BEGIN
			IF @Override = 1
				BEGIN
					PRINT 'Creating data flow.'

					INSERT INTO [metadata].[DataFlows]
						(
						[DataFlowName],
						[InUse]
						)
					VALUES
						(
						@DataFlowName,
						1
						)

					SET @NewDataFlow = SCOPE_IDENTITY()
				END
			ELSE
				BEGIN
					RAISERROR('Data flow name does not exist.',16,1);
					RETURN;
				END
		END
		ELSE
		BEGIN
			PRINT 'Found data flow.'
			
			SELECT
				@NewDataFlow = [DataFlowId]
			FROM
				[metadata].[DataFlows]
			WHERE
				[DataFlowName] = @DataFlowName
		END

	
	---------------------------------------------------------------------------------------------
	--									source system
	---------------------------------------------------------------------------------------------
	IF NOT EXISTS
		(
		SELECT * FROM [metadata].[Systems] WHERE [SystemName] = @SourceSystem
		)
		BEGIN
			IF @Override = 1
				BEGIN
					PRINT 'Creating source system.'
					
					INSERT INTO [metadata].[Systems]
						(
						[SystemName],
						[SystemTechnologyId],
						[CreatedDate]
						)
					SELECT
						@SourceSystem,
						[SystemTechId],
						GETDATE()
					FROM
						[metadata].[SystemTechnologies]
					WHERE
						[TechnologyName] = 'Unknown'

					SET @NewSourceSystem = SCOPE_IDENTITY()
				END
			ELSE
				BEGIN		
					RAISERROR('Source system does not exist.',16,1);
					RETURN;
				END
		END
		ELSE
		BEGIN
			PRINT 'Found source system.'
			
			SELECT
				@NewSourceSystem = [SystemId]
			FROM
				[metadata].[Systems]
			WHERE
				[SystemName] = @SourceSystem
		END


	---------------------------------------------------------------------------------------------
	--									target system
	---------------------------------------------------------------------------------------------
	IF NOT EXISTS
		(
		SELECT * FROM [metadata].[Systems] WHERE [SystemName] = @TargetSystem
		)
		BEGIN
			IF @Override = 1
				BEGIN
					PRINT 'Creating target system.'

					INSERT INTO [metadata].[Systems]
						(
						[SystemName],
						[SystemTechnologyId],
						[CreatedDate]
						)
					SELECT
						@TargetSystem,
						[SystemTechId],
						GETDATE()
					FROM
						[metadata].[SystemTechnologies]
					WHERE
						[TechnologyName] = 'Unknown'
				
					SET @NewTargetSystem = SCOPE_IDENTITY()
				END
			ELSE
				BEGIN		
					RAISERROR('Target system does not exist.',16,1);
					RETURN;
				END
		END
		ELSE
		BEGIN
			PRINT 'Found target system.'
			
			SELECT
				@NewTargetSystem = [SystemId]
			FROM
				[metadata].[Systems]
			WHERE
				[SystemName] = @TargetSystem
		END


	---------------------------------------------------------------------------------------------
	--									source object
	---------------------------------------------------------------------------------------------
	IF NOT EXISTS
		(
		SELECT * FROM [metadata].[Objects] WHERE [ObjectName] = @SourceObject AND [ObjectPrefix] = @SourceObjectPrefix AND [SystemId] = @NewSourceSystem
		)
		BEGIN
			IF @Override = 1
				BEGIN
					PRINT 'Creating source object.'
					
					INSERT INTO [metadata].[Objects]
						(
						[ObjectTypeId],
						[ObjectPrefix],
						[ObjectName],
						[SystemId]
						)
					SELECT
						[ObjectTypeId],
						@SourceObjectPrefix,
						@SourceObject,
						@NewSourceSystem
					FROM
						[metadata].[ObjectTypes]
					WHERE
						[ObjectTypeName] = 'Unknown'

					SET @NewSourceObject = SCOPE_IDENTITY()
				END
			ELSE
				BEGIN
					RAISERROR('Source object does not exist.',16,1);
					RETURN;
				END
		END
		ELSE
		BEGIN
			PRINT 'Found source object.'
			
			SELECT
				@NewSourceObject = [ObjectId]
			FROM
				[metadata].[Objects]
			WHERE
				[ObjectName] = @SourceObject
				AND [ObjectPrefix] = @SourceObjectPrefix 
				AND [SystemId] = @NewSourceSystem
		END


	---------------------------------------------------------------------------------------------
	--									target object
	---------------------------------------------------------------------------------------------
	IF NOT EXISTS
		(
		SELECT * FROM [metadata].[Objects] WHERE [ObjectName] = @TargetObject AND [ObjectPrefix] = @TargetObjectPrefix AND [SystemId] = @NewTargetSystem
		)
		BEGIN
			IF @Override = 1
				BEGIN
					PRINT 'Creating target object.'
					
					INSERT INTO [metadata].[Objects]
						(
						[ObjectTypeId],
						[ObjectPrefix],
						[ObjectName],
						[SystemId]
						)
					SELECT
						[ObjectTypeId],
						@TargetObjectPrefix,
						@TargetObject,
						@NewTargetSystem
					FROM
						[metadata].[ObjectTypes]
					WHERE
						[ObjectTypeName] = 'Unknown'

					SET @NewTargetObject = SCOPE_IDENTITY()
				END
			ELSE
				BEGIN
					RAISERROR('Target object does not exist.',16,1);
					RETURN;
				END
		END
		ELSE
		BEGIN
			PRINT 'Found target object.'
			
			SELECT
				@NewTargetObject = [ObjectId]
			FROM
				[metadata].[Objects]
			WHERE
				[ObjectName] = @TargetObject
				AND [ObjectPrefix] = @TargetObjectPrefix 
				AND [SystemId] = @NewTargetSystem
		END


	---------------------------------------------------------------------------------------------
	--									source attribute
	---------------------------------------------------------------------------------------------
	IF NOT EXISTS
		(
		SELECT * FROM [metadata].[Attributes] WHERE [AttributeName] = @SourceAttribute AND [ObjectId] = @NewSourceObject
		)
		BEGIN
			IF @Override = 1
				BEGIN
					PRINT 'Creating source attribute.'
					
					INSERT INTO [metadata].[Attributes]
						(
						[AttributeName],
						[DataType],
						[ObjectId]
						)
					VALUES
						( 
						@SourceAttribute,
						@SourceDataType,
						@NewSourceObject
						)

					SET @NewSourceAttribute = SCOPE_IDENTITY()
				END
			ELSE
				BEGIN
					RAISERROR('Source attribute does not exist.',16,1);
					RETURN;
				END
		END
		ELSE
		BEGIN
			PRINT 'Found source attribute.'
			
			SELECT
				@NewSourceAttribute = [AttributeId]
			FROM
				[metadata].[Attributes]
			WHERE
				[AttributeName] = @SourceAttribute
				AND [ObjectId] = @NewSourceObject
		END

	---------------------------------------------------------------------------------------------
	--									target attribute
	---------------------------------------------------------------------------------------------
	IF NOT EXISTS
		(
		SELECT * FROM [metadata].[Attributes] WHERE [AttributeName] = @TargetAttribute AND [ObjectId] = @NewTargetObject
		)
		BEGIN
			IF @Override = 1
				BEGIN
					PRINT 'Creating target attribute.'
					
					INSERT INTO [metadata].[Attributes]
						(
						[AttributeName],
						[DataType],
						[ObjectId]
						)
					VALUES
						( 
						@TargetAttribute,
						@TargetDataType,
						@NewTargetObject
						)

					SET @NewTargetAttribute = SCOPE_IDENTITY()
				END
			ELSE
				BEGIN
					RAISERROR('Target attribute does not exist.',16,1);
					RETURN;
				END
		END
		ELSE
		BEGIN
			PRINT 'Found target attribute.'
			
			SELECT
				@NewTargetAttribute = [AttributeId]
			FROM
				[metadata].[Attributes]
			WHERE
				[AttributeName] = @TargetAttribute
				AND [ObjectId] = @NewTargetObject
		END


	---------------------------------------------------------------------------------------------
	--									final mapping insert
	---------------------------------------------------------------------------------------------
	INSERT INTO [metadata].[Mappings]
		( 
		[DataFlowId],
		[SourceSystemId],
		[SourceObjectId],
		[SourceAttributeId],
		[TargetSystemId],
		[TargetObjectId],
		[TargetAttributeId],
		[InUse]
		)
	VALUES
		(
		@NewDataFlow,
		@NewSourceSystem,
		@NewSourceObject, 
		@NewSourceAttribute, 
		@NewTargetSystem, 
		@NewTargetObject,
		@NewTargetAttribute,
		1
		)
	
	SET @NewMapping = SCOPE_IDENTITY()
	
	IF @Override = 1
	BEGIN
		PRINT 'Mapping added, double check system technology and object type settings.'
	END

	SELECT * FROM [metadata].[CompleteMappings] WHERE [MappingId] = @NewMapping

END
GO
/****** Object:  StoredProcedure [metadata].[CreateUSQLExtractMapOutput]    Script Date: 15/05/2018 09:43:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [metadata].[CreateUSQLExtractMapOutput]
	(
	@DataFlowName VARCHAR(255),
	@CodeSnippet NVARCHAR(MAX) OUTPUT,
	@DebugMode BIT = 0
	)
AS

SET NOCOUNT ON;

BEGIN
	/* for development:
	DECLARE @DataFlowName VARCHAR(255) = 'PatientsRawToBase'
	DECLARE @CodeSnippet NVARCHAR(MAX) 
	DECLARE @DebugMode BIT = 1
	*/

	--defensive checks
	IF NOT EXISTS
		(
		SELECT * FROM [metadata].[DataFlows] WHERE [DataFlowName] = @DataFlowName
		)
		BEGIN
			RAISERROR('Data flow name does not exist.',16,1);
			RETURN;
		END

	---------------------------------------------------------------------------------------------
	--									extractor field list
	---------------------------------------------------------------------------------------------
	DECLARE @FieldList NVARCHAR(MAX) = ''

	SELECT
		@FieldList += '[' + [SourceAttribute] + '] ' + [SourceDataType] + ',' + CHAR(13) + CHAR(9) + CHAR(9)
	FROM
		[metadata].[CompleteMappings]
	WHERE
		[DataFlowName] = @DataFlowName

	SET @FieldList = [metadata].[RemoveLastComma](@FieldList)

	---------------------------------------------------------------------------------------------
	--									extractor type, path and additions
	---------------------------------------------------------------------------------------------
	DECLARE @SourceObjectType VARCHAR(128)
	DECLARE @SourceObjectAdditions VARCHAR(128)
	DECLARE @SourceObjectPath VARCHAR(128)

	SELECT
		@SourceObjectType = [metadata].[UpperCaseFirstChar]([SourceObjectType]),
		@SourceObjectAdditions = ISNULL([SourceObjectAdditions],''),
		@SourceObjectPath = '/' + [SourcePrefix] + '/' + [SourceObject] + '.' + [SourceObjectType]
	FROM
		[metadata].[SourceObjects]
	WHERE
		[DataFlowName] = @DataFlowName

	---------------------------------------------------------------------------------------------
	--									mappings
	---------------------------------------------------------------------------------------------
	DECLARE @Mappings NVARCHAR(MAX) = ''

	SELECT
		@Mappings += '[' + [SourceAttribute] + '] AS ' + [TargetAttribute] + ',' + CHAR(13) + CHAR(9) + CHAR(9)
	FROM
		[metadata].[CompleteMappings]
	WHERE
		[DataFlowName] = @DataFlowName

	SET @Mappings = [metadata].[RemoveLastComma](@Mappings)

	---------------------------------------------------------------------------------------------
	--									outputter type, path and additions
	---------------------------------------------------------------------------------------------
	DECLARE @TargetObjectType VARCHAR(128)
	DECLARE @TargetObjectAdditions VARCHAR(128)
	DECLARE @TargetObjectPath VARCHAR(128)

	SELECT
		@TargetObjectType = [metadata].[UpperCaseFirstChar]([TargetObjectType]),
		@TargetObjectAdditions = ISNULL([TargetObjectAdditions],''),
		@TargetObjectPath = '/' + [TargetPrefix] + '/' + [TargetObject] + '.' + [TargetObjectType]
	FROM
		[metadata].[TargetObjects]
	WHERE
		[DataFlowName] = @DataFlowName

	---------------------------------------------------------------------------------------------
	--								create final USQL script
	---------------------------------------------------------------------------------------------
	DECLARE @USQL NVARCHAR(MAX)

	SELECT
		@USQL = sp.[Script],
		@USQL = REPLACE(@USQL,'<##SourceObjectPath##>',@SourceObjectPath),
		@USQL = REPLACE(@USQL,'<##TargetObjectPath##>',@TargetObjectPath),
		@USQL = REPLACE(@USQL,'<##SourceAttributes##>',@FieldList),
		@USQL = REPLACE(@USQL,'<##SourceObjectType##>',@SourceObjectType),
		@USQL = REPLACE(@USQL,'<##SourceObjectAdditions##>',@SourceObjectAdditions),
		@USQL = REPLACE(@USQL,'<##SourceToTargetAttributes##>',@Mappings),
		@USQL = REPLACE(@USQL,'<##TargetObjectType##>',@TargetObjectType),
		@USQL = REPLACE(@USQL,'<##TargetObjectAdditions##>',@TargetObjectAdditions),
		@CodeSnippet = @USQL
	FROM
		[metadata].[ScriptParts] sp
		INNER JOIN [metadata].[DataFlows] df
			ON sp.[ScriptId] = df.[ScriptId]
	WHERE
		df.[DataFlowName] = @DataFlowName
	
	IF @DebugMode = 1 EXEC [dbo].[usp_PrintBig] @USQL

END
GO
/****** Object:  StoredProcedure [metadata].[CreateUSQLExtractMapTable]    Script Date: 15/05/2018 09:43:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [metadata].[CreateUSQLExtractMapTable]
	(
	@DataFlowName VARCHAR(255),
	@CodeSnippet NVARCHAR(MAX) OUTPUT,
	@DebugMode BIT = 0
	)
AS

SET NOCOUNT ON;

BEGIN
	 /* for development:
	DECLARE @DataFlowName VARCHAR(255) = 'PatientsRawToBase'
	DECLARE @CodeSnippet NVARCHAR(MAX) 
	DECLARE @DebugMode BIT = 1
	*/

	--defensive checks
	IF NOT EXISTS
		(
		SELECT * FROM [metadata].[DataFlows] WHERE [DataFlowName] = @DataFlowName
		)
		BEGIN
			RAISERROR('Data flow name does not exist.',16,1);
			RETURN;
		END

	---------------------------------------------------------------------------------------------
	--									extractor field list
	---------------------------------------------------------------------------------------------
	DECLARE @FieldList NVARCHAR(MAX) = ''

	SELECT
		@FieldList += '[' + [SourceAttribute] + '] ' + [SourceDataType] + ',' + CHAR(13) + CHAR(9) + CHAR(9)
	FROM
		[metadata].[CompleteMappings]
	WHERE
		[DataFlowName] = @DataFlowName

	SET @FieldList = [metadata].[RemoveLastComma](@FieldList)

	---------------------------------------------------------------------------------------------
	--									extractor type, path and additions
	---------------------------------------------------------------------------------------------
	DECLARE @SourceObjectType VARCHAR(128)
	DECLARE @SourceObjectAdditions VARCHAR(128)
	DECLARE @SourceObjectPath VARCHAR(128)

	SELECT
		@SourceObjectType = [metadata].[UpperCaseFirstChar]([SourceObjectType]),
		@SourceObjectAdditions = ISNULL([SourceObjectAdditions],''),
		@SourceObjectPath = '/' + [SourcePrefix] + '/' + [SourceObject] + '.' + [SourceObjectType]
	FROM
		[metadata].[SourceObjects]
	WHERE
		[DataFlowName] = @DataFlowName

	---------------------------------------------------------------------------------------------
	--									mappings
	---------------------------------------------------------------------------------------------
	DECLARE @Mappings NVARCHAR(MAX) = ''

	SELECT
		@Mappings += '[' + [SourceAttribute] + '] AS ' + [TargetAttribute] + ',' + CHAR(13) + CHAR(9) + CHAR(9)
	FROM
		[metadata].[CompleteMappings]
	WHERE
		[DataFlowName] = @DataFlowName

	SET @Mappings = [metadata].[RemoveLastComma](@Mappings)

	---------------------------------------------------------------------------------------------
	--									target attributes
	---------------------------------------------------------------------------------------------
	DECLARE @TargetFieldList NVARCHAR(MAX) = ''

	SELECT
		@TargetFieldList += '[' + [TargetAttribute] + '],' + CHAR(13) + CHAR(9)
	FROM
		[metadata].[CompleteMappings]
	WHERE
		[DataFlowName] = @DataFlowName

	SET @TargetFieldList = [metadata].[RemoveLastComma](@TargetFieldList)

	---------------------------------------------------------------------------------------------
	--									output table
	---------------------------------------------------------------------------------------------
	DECLARE @TargetObjectPath VARCHAR(128)

	SELECT
		@TargetObjectPath = QUOTENAME([TargetPrefix]) + '.' + QUOTENAME([TargetObject])
	FROM
		[metadata].[TargetObjects]
	WHERE
		[DataFlowName] = @DataFlowName

	---------------------------------------------------------------------------------------------
	--								create final USQL script
	---------------------------------------------------------------------------------------------
	DECLARE @USQL NVARCHAR(MAX)

	SELECT
		@USQL = sp.[Script],
		@USQL = REPLACE(@USQL,'<##SourceObjectPath##>',@SourceObjectPath),
		@USQL = REPLACE(@USQL,'<##TargetObjectPath##>',@TargetObjectPath),
		@USQL = REPLACE(@USQL,'<##SourceAttributes##>',@FieldList),
		@USQL = REPLACE(@USQL,'<##SourceObjectType##>',@SourceObjectType),
		@USQL = REPLACE(@USQL,'<##SourceObjectAdditions##>',@SourceObjectAdditions),
		@USQL = REPLACE(@USQL,'<##SourceToTargetAttributes##>',@Mappings),
		@USQL = REPLACE(@USQL,'<##TargetAttributes##>',@TargetFieldList),
		@CodeSnippet = @USQL
	FROM
		[metadata].[ScriptParts] sp
		INNER JOIN [metadata].[DataFlows] df
			ON sp.[ScriptId] = df.[ScriptId]
	WHERE
		df.[DataFlowName] = @DataFlowName

	IF @DebugMode = 1 EXEC [dbo].[usp_PrintBig] @USQL

END
GO
/****** Object:  StoredProcedure [metadata].[CreateUSQLExtractMergeTable]    Script Date: 15/05/2018 09:43:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [metadata].[CreateUSQLExtractMergeTable]
	(
	@DataFlowName VARCHAR(255),
	@CodeSnippet NVARCHAR(MAX) OUTPUT,
	@DebugMode BIT = 0
	)
AS

SET NOCOUNT ON;

BEGIN
	/*for development:
	DECLARE @DataFlowName VARCHAR(255) = 'PatientsRawToBase'
	DECLARE @CodeSnippet NVARCHAR(MAX) 
	DECLARE @DebugMode BIT = 1
	*/

	--defensive checks
	IF NOT EXISTS
		(
		SELECT * FROM [metadata].[DataFlows] WHERE [DataFlowName] = @DataFlowName
		)
		BEGIN
			RAISERROR('Data flow name does not exist.',16,1);
			RETURN;
		END

	---------------------------------------------------------------------------------------------
	--									extractor field list
	---------------------------------------------------------------------------------------------
	DECLARE @FieldList NVARCHAR(MAX) = ''

	SELECT
		@FieldList += '[' + [SourceAttribute] + '] ' + [SourceDataType] + ',' + CHAR(13) + CHAR(9) + CHAR(9)
	FROM
		[metadata].[CompleteMappings]
	WHERE
		[DataFlowName] = @DataFlowName

	SET @FieldList = [metadata].[RemoveLastComma](@FieldList)

	---------------------------------------------------------------------------------------------
	--									extractor type, path and additions
	---------------------------------------------------------------------------------------------
	DECLARE @SourceObjectType VARCHAR(128)
	DECLARE @SourceObjectAdditions VARCHAR(128)
	DECLARE @SourceObjectPath VARCHAR(128)

	SELECT
		@SourceObjectType = [metadata].[UpperCaseFirstChar]([SourceObjectType]),
		@SourceObjectAdditions = ISNULL([SourceObjectAdditions],''),
		@SourceObjectPath = '/' + [SourcePrefix] + '/' + [SourceObject] + '.' + [SourceObjectType]
	FROM
		[metadata].[SourceObjects]
	WHERE
		[DataFlowName] = @DataFlowName

	---------------------------------------------------------------------------------------------
	--									merge mappings
	---------------------------------------------------------------------------------------------
	DECLARE @SourceMergeMappings NVARCHAR(MAX) = ''
	DECLARE @TargetMergeMappings NVARCHAR(MAX) = ''
	DECLARE @SoureToTargetMerge NVARCHAR(MAX) = ''

	SELECT
		@SourceMergeMappings += 'source.[' + [SourceAttribute] + '] AS src' + [SourceAttribute] + ',' + CHAR(13) + CHAR(9) + CHAR(9) + CHAR(9)
	FROM
		[metadata].[CompleteMappings]
	WHERE
		[DataFlowName] = @DataFlowName

	SET @SourceMergeMappings = [metadata].[RemoveEndChar](@SourceMergeMappings)

	SELECT
		@TargetMergeMappings += 'Target.[' + [TargetAttribute] + '] AS tgt' + [TargetAttribute] + ',' + CHAR(13) + CHAR(9) + CHAR(9) + CHAR(9)
	FROM
		[metadata].[CompleteMappings]
	WHERE
		[DataFlowName] = @DataFlowName

	SET @TargetMergeMappings = [metadata].[RemoveLastComma](@TargetMergeMappings)

	SELECT
		@SoureToTargetMerge += '(' + [SourceDataType] + ')([checkFlag] ? [src' + [SourceAttribute] +'] : [tgt' + [TargetAttribute] + ']) AS ' + [TargetAttribute] + ',' + CHAR(13) + CHAR(9) + CHAR(9)
	FROM
		[metadata].[CompleteMappings]
	WHERE
		[DataFlowName] = @DataFlowName

	SET @SoureToTargetMerge = [metadata].[RemoveLastComma](@SoureToTargetMerge)

	---------------------------------------------------------------------------------------------
	--									primary keys
	---------------------------------------------------------------------------------------------
	DECLARE @SourceAttributePK NVARCHAR(MAX)
	DECLARE @TargetAttributePK NVARCHAR(MAX)

	SELECT
		@SourceAttributePK = [SourceAttribute]
	FROM
		[metadata].[CompleteMappings]
	WHERE
		[DataFlowName] = @DataFlowName
		AND [SourcePrimaryKey] IS NOT NULL

	SELECT
		@TargetAttributePK = [TargetAttribute]
	FROM
		[metadata].[CompleteMappings]
	WHERE
		[DataFlowName] = @DataFlowName
		AND [TargetPrimaryKey] IS NOT NULL

	---------------------------------------------------------------------------------------------
	--									target attributes
	---------------------------------------------------------------------------------------------
	DECLARE @TargetFieldList NVARCHAR(MAX) = ''

	SELECT
		@TargetFieldList += '[' + [TargetAttribute] + '],' + CHAR(13) + CHAR(9)
	FROM
		[metadata].[CompleteMappings]
	WHERE
		[DataFlowName] = @DataFlowName

	SET @TargetFieldList = [metadata].[RemoveLastComma](@TargetFieldList)

	---------------------------------------------------------------------------------------------
	--									output table
	---------------------------------------------------------------------------------------------
	DECLARE @TargetObjectPath VARCHAR(128)

	SELECT
		@TargetObjectPath = QUOTENAME([TargetPrefix]) + '.' + QUOTENAME([TargetObject])
	FROM
		[metadata].[TargetObjects]
	WHERE
		[DataFlowName] = @DataFlowName

	---------------------------------------------------------------------------------------------
	--								create final USQL script
	---------------------------------------------------------------------------------------------
	DECLARE @USQL NVARCHAR(MAX)

	SELECT
		@USQL = sp.[Script],
		@USQL = REPLACE(@USQL,'<##SourceObjectPath##>',@SourceObjectPath),
		@USQL = REPLACE(@USQL,'<##TargetObjectPath##>',@TargetObjectPath),


		@USQL = REPLACE(@USQL,'<##SourceAttributes##>',@FieldList),
		@USQL = REPLACE(@USQL,'<##SourceObjectType##>',@SourceObjectType),
		@USQL = REPLACE(@USQL,'<##SourceObjectAdditions##>',@SourceObjectAdditions),
		

		@USQL = REPLACE(@USQL,'<##SourceMergeMappings##>',@SourceMergeMappings),
		@USQL = REPLACE(@USQL,'<##TargetMergeMappings##>',@TargetMergeMappings),
		@USQL = REPLACE(@USQL,'<##SoureToTargetMerge##>',@SoureToTargetMerge),
		
		@USQL = REPLACE(@USQL,'<##SourceAttributePK##>',@SourceAttributePK),
		@USQL = REPLACE(@USQL,'<##TargetAttributePK##>',@TargetAttributePK),
		

		@USQL = REPLACE(@USQL,'<##TargetAttributes##>',@TargetFieldList),


		@CodeSnippet = @USQL
	FROM
		[metadata].[ScriptParts] sp
		INNER JOIN [metadata].[DataFlows] df
			ON sp.[ScriptId] = df.[ScriptId]
	WHERE
		df.[DataFlowName] = @DataFlowName

	IF @DebugMode = 1 EXEC [dbo].[usp_PrintBig] @USQL

END
GO
/****** Object:  StoredProcedure [metadata].[CreateUSQLTableMapOutput]    Script Date: 15/05/2018 09:43:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [metadata].[CreateUSQLTableMapOutput]
	(
	@DataFlowName VARCHAR(255),
	@CodeSnippet NVARCHAR(MAX) OUTPUT,
	@DebugMode BIT = 0
	)
AS

SET NOCOUNT ON;

BEGIN
	/*for development:
	DECLARE @DataFlowName VARCHAR(255) = 'PatientsRawToBase'
	DECLARE @CodeSnippet NVARCHAR(MAX) 
	DECLARE @DebugMode BIT = 1
	*/

	--defensive checks
	IF NOT EXISTS
		(
		SELECT * FROM [metadata].[DataFlows] WHERE [DataFlowName] = @DataFlowName
		)
		BEGIN
			RAISERROR('Data flow name does not exist.',16,1);
			RETURN;
		END

	---------------------------------------------------------------------------------------------
	--									source table field list
	---------------------------------------------------------------------------------------------
	DECLARE @FieldList NVARCHAR(MAX) = ''

	SELECT
		@FieldList += '[' + [SourceAttribute] + '],' + CHAR(13) + CHAR(9) + CHAR(9)
	FROM
		[metadata].[CompleteMappings]
	WHERE
		[DataFlowName] = @DataFlowName

	SET @FieldList = [metadata].[RemoveLastComma](@FieldList)

	---------------------------------------------------------------------------------------------
	--									table path
	---------------------------------------------------------------------------------------------
	DECLARE @SourceObjectPath VARCHAR(128)

	SELECT
		@SourceObjectPath = QUOTENAME([SourcePrefix]) + '.' + QUOTENAME([SourceObject])
	FROM
		[metadata].[SourceObjects]
	WHERE
		[DataFlowName] = @DataFlowName	

	---------------------------------------------------------------------------------------------
	--									mappings
	---------------------------------------------------------------------------------------------
	DECLARE @Mappings NVARCHAR(MAX) = ''

	SELECT
		@Mappings += '[' + [SourceAttribute] + '] AS ' + [TargetAttribute] + ',' + CHAR(13) + CHAR(9) + CHAR(9)
	FROM
		[metadata].[CompleteMappings]
	WHERE
		[DataFlowName] = @DataFlowName

	SET @Mappings = [metadata].[RemoveLastComma](@Mappings)

	---------------------------------------------------------------------------------------------
	--									target attributes
	---------------------------------------------------------------------------------------------
	DECLARE @TargetFieldList NVARCHAR(MAX) = ''

	SELECT
		@TargetFieldList += '[' + [TargetAttribute] + '],' + CHAR(13) + CHAR(9)
	FROM
		[metadata].[CompleteMappings]
	WHERE
		[DataFlowName] = @DataFlowName

	SET @TargetFieldList = [metadata].[RemoveLastComma](@TargetFieldList)

	---------------------------------------------------------------------------------------------
	--									output trable
	---------------------------------------------------------------------------------------------
	DECLARE @TargetObjectType VARCHAR(128)
	DECLARE @TargetObjectAdditions VARCHAR(128)
	DECLARE @TargetObjectPath VARCHAR(128)

	SELECT
		@TargetObjectType = [metadata].[UpperCaseFirstChar]([TargetObjectType]),
		@TargetObjectAdditions = ISNULL([TargetObjectAdditions],''),
		@TargetObjectPath = '/' + [TargetPrefix] + '/' + [TargetObject] + '.' + [TargetObjectType]
	FROM
		[metadata].[TargetObjects]
	WHERE
		[DataFlowName] = @DataFlowName

	---------------------------------------------------------------------------------------------
	--								create final USQL script
	---------------------------------------------------------------------------------------------
	DECLARE @USQL NVARCHAR(MAX)

	SELECT
		@USQL = sp.[Script],
		@USQL = REPLACE(@USQL,'<##SourceObjectPath##>',@SourceObjectPath),
		@USQL = REPLACE(@USQL,'<##TargetObjectPath##>',@TargetObjectPath),
		@USQL = REPLACE(@USQL,'<##SourceAttributes##>',@FieldList),
		@USQL = REPLACE(@USQL,'<##SourceToTargetAttributes##>',@Mappings),
		@USQL = REPLACE(@USQL,'<##TargetObjectType##>',@TargetObjectType),
		@USQL = REPLACE(@USQL,'<##TargetObjectAdditions##>',@TargetObjectAdditions),
		@CodeSnippet = @USQL
	FROM
		[metadata].[ScriptParts] sp
		INNER JOIN [metadata].[DataFlows] df
			ON sp.[ScriptId] = df.[ScriptId]
	WHERE
		df.[DataFlowName] = @DataFlowName

	IF @DebugMode = 1 EXEC [dbo].[usp_PrintBig] @USQL

END
GO
/****** Object:  StoredProcedure [metadata].[CreateUSQLTableMapTable]    Script Date: 15/05/2018 09:43:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [metadata].[CreateUSQLTableMapTable]
	(
	@DataFlowName VARCHAR(255),
	@CodeSnippet NVARCHAR(MAX) OUTPUT,
	@DebugMode BIT = 0
	)
AS

SET NOCOUNT ON;

BEGIN
	/*for development:
	DECLARE @DataFlowName VARCHAR(255) = 'PatientsRawToBase'
	DECLARE @CodeSnippet NVARCHAR(MAX) 
	DECLARE @DebugMode BIT = 1
	*/

	--defensive checks
	IF NOT EXISTS
		(
		SELECT * FROM [metadata].[DataFlows] WHERE [DataFlowName] = @DataFlowName
		)
		BEGIN
			RAISERROR('Data flow name does not exist.',16,1);
			RETURN;
		END

	---------------------------------------------------------------------------------------------
	--									source table field list
	---------------------------------------------------------------------------------------------
	DECLARE @FieldList NVARCHAR(MAX) = ''

	SELECT
		@FieldList += '[' + [SourceAttribute] + '],' + CHAR(13) + CHAR(9) + CHAR(9)
	FROM
		[metadata].[CompleteMappings]
	WHERE
		[DataFlowName] = @DataFlowName

	SET @FieldList = [metadata].[RemoveLastComma](@FieldList)

	---------------------------------------------------------------------------------------------
	--									table path
	---------------------------------------------------------------------------------------------
	DECLARE @SourceObjectPath VARCHAR(128)

	SELECT
		@SourceObjectPath = QUOTENAME([SourcePrefix]) + '.' + QUOTENAME([SourceObject])
	FROM
		[metadata].[SourceObjects]
	WHERE
		[DataFlowName] = @DataFlowName	

	---------------------------------------------------------------------------------------------
	--									mappings
	---------------------------------------------------------------------------------------------
	DECLARE @Mappings NVARCHAR(MAX) = ''

	SELECT
		@Mappings += '[' + [SourceAttribute] + '] AS ' + [TargetAttribute] + ',' + CHAR(13) + CHAR(9) + CHAR(9)
	FROM
		[metadata].[CompleteMappings]
	WHERE
		[DataFlowName] = @DataFlowName

	SET @Mappings = [metadata].[RemoveLastComma](@Mappings)

	---------------------------------------------------------------------------------------------
	--									target attributes
	---------------------------------------------------------------------------------------------
	DECLARE @TargetFieldList NVARCHAR(MAX) = ''

	SELECT
		@TargetFieldList += '[' + [TargetAttribute] + '],' + CHAR(13) + CHAR(9)
	FROM
		[metadata].[CompleteMappings]
	WHERE
		[DataFlowName] = @DataFlowName

	SET @TargetFieldList = [metadata].[RemoveLastComma](@TargetFieldList)

	---------------------------------------------------------------------------------------------
	--									output table
	---------------------------------------------------------------------------------------------
	DECLARE @TargetObjectPath VARCHAR(128)

	SELECT
		@TargetObjectPath = QUOTENAME([TargetPrefix]) + '.' + QUOTENAME([TargetObject])
	FROM
		[metadata].[TargetObjects]
	WHERE
		[DataFlowName] = @DataFlowName

	---------------------------------------------------------------------------------------------
	--								create final USQL script
	---------------------------------------------------------------------------------------------
	DECLARE @USQL NVARCHAR(MAX)

	SELECT
		@USQL = sp.[Script],
		@USQL = REPLACE(@USQL,'<##SourceObjectPath##>',@SourceObjectPath),
		@USQL = REPLACE(@USQL,'<##SourceAttributes##>',@FieldList),
		@USQL = REPLACE(@USQL,'<##SourceToTargetAttributes##>',@Mappings),
		@USQL = REPLACE(@USQL,'<##TargetAttributes##>',@TargetFieldList),
		@USQL = REPLACE(@USQL,'<##TargetObjectPath##>',@TargetObjectPath),
		@CodeSnippet = @USQL
	FROM
		[metadata].[ScriptParts] sp
		INNER JOIN [metadata].[DataFlows] df
			ON sp.[ScriptId] = df.[ScriptId]
	WHERE
		df.[DataFlowName] = @DataFlowName

	IF @DebugMode = 1 EXEC [dbo].[usp_PrintBig] @USQL

END
GO
/****** Object:  StoredProcedure [metadata].[GetUSQLStoredProcedure]    Script Date: 15/05/2018 09:43:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [metadata].[GetUSQLStoredProcedure]
	(
	@DataFlowName VARCHAR(255),
	@USQL NVARCHAR(MAX) OUTPUT,
	@DebugMode BIT = 0
	)
AS
BEGIN
	/*for development:
	DECLARE @DataFlowName VARCHAR(255) = 'PatientsRawToBase'
	DECLARE @USQL NVARCHAR(MAX) 
	DECLARE @DebugMode BIT = 1
	*/

	--checks
	IF NOT EXISTS
		(
		SELECT * FROM [metadata].[DataFlows] WHERE [DataFlowName] = @DataFlowName
		)
		BEGIN
			RAISERROR('Invalid data flow name provided.',16,1);
			RETURN;
		END
	
	--get script for data flow
	DECLARE @ScriptName VARCHAR(128)
	DECLARE @ProcedureBody NVARCHAR(MAX)

	SELECT
		@ScriptName = sp.[ScriptName]
	FROM 
		[metadata].[DataFlows] df
		INNER JOIN [metadata].[ScriptParts] sp
			ON df.[ScriptId] = sp.[ScriptId]
	WHERE 
		df.[DataFlowName] = @DataFlowName

	--create stored procedure body for script type
	IF @ScriptName = 'ExtractMapOutput'
		BEGIN
			EXEC [metadata].[CreateUSQLExtractMapOutput]
				@DataFlowName = @DataFlowName,
				@CodeSnippet = @ProcedureBody OUTPUT
		END
	ELSE IF @ScriptName = 'ExtractMapTable'
		BEGIN
			EXEC [metadata].[CreateUSQLExtractMapTable]
				@DataFlowName = @DataFlowName,
				@CodeSnippet = @ProcedureBody OUTPUT
		END
	ELSE IF @ScriptName = 'TableMapOutput'
		BEGIN
			EXEC [metadata].[CreateUSQLTableMapOutput]
				@DataFlowName = @DataFlowName,
				@CodeSnippet = @ProcedureBody OUTPUT
		END
 	ELSE IF @ScriptName = 'TableMapTable'
		BEGIN
			EXEC [metadata].[CreateUSQLTableMapTable]
				@DataFlowName = @DataFlowName,
				@CodeSnippet = @ProcedureBody OUTPUT
		END
 	ELSE IF @ScriptName = 'ExtractMergeTable'
		BEGIN
			EXEC [metadata].[CreateUSQLExtractMergeTable]
				@DataFlowName = @DataFlowName,
				@CodeSnippet = @ProcedureBody OUTPUT
		END
	ELSE
		BEGIN
			RAISERROR('No valid script available for data flow.',16,1)
			RETURN;
		END
	
	--wrap proc body with ddl code   
	SELECT
		@USQL = [Script],
		@USQL = REPLACE(@USQL,'<##TransformationSchema##>',[dbo].[GetProperty]('TransformationSchema')),
		@USQL = REPLACE(@USQL,'<##ProcedureName##>','usp_' + @DataFlowName),
		@USQL = REPLACE(@USQL,'<##CodeRefreshDate##>',CONVERT(VARCHAR,GETDATE(),103)),
		@USQL = REPLACE(@USQL,'<##CodeBody##>',@ProcedureBody)
	FROM
		[metadata].[ScriptParts]
	WHERE
		[ScriptName] = 'StoredProcedureWrapper'
	
	--add use database statement
	SELECT
		@USQL = [Script] + CHAR(13) + CHAR(13) + @USQL,
		@USQL = REPLACE(@USQL,'<##TransformationDB##>',[dbo].[GetProperty]('TransformationDB'))
	FROM
		[metadata].[ScriptParts]
	WHERE
		[ScriptName] = 'UseDatabase'

	IF @DebugMode = 1 EXEC [dbo].[usp_PrintBig] @USQL

END
GO
/****** Object:  StoredProcedure [metadata].[GetUSQLStoredProcedureFile]    Script Date: 15/05/2018 09:43:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [metadata].[GetUSQLStoredProcedureFile]
	(
	@DataFlowName VARCHAR(255),
	@USQL NVARCHAR(MAX) OUTPUT,
	@DebugMode BIT = 0
	)
AS
BEGIN
	/*for development:
	DECLARE @DataFlowName VARCHAR(255) = 'PatientsRawToBase'
	DECLARE @USQL NVARCHAR(MAX) 
	DECLARE @DebugMode BIT = 1
	*/

	IF NOT EXISTS
		(
		SELECT * FROM [metadata].[DataFlows] WHERE [DataFlowName] = @DataFlowName
		)
		BEGIN
			RAISERROR('Invalid data flow name provided.',16,1);
			RETURN;
		END

	SELECT
		@USQL = 
'/*
Adatis - Auto Generated USQL File

File Generated Date: <##CodeRefreshDate##>
*/
' + CHAR(13) + [Script] + CHAR(13) + '[' + [dbo].[GetProperty]('TransformationSchema') + '].[' + @DataFlowName + ']();
		',
		@USQL = REPLACE(@USQL,'<##TransformationDB##>',[dbo].[GetProperty]('TransformationDB')),
		@USQL = REPLACE(@USQL,'<##CodeRefreshDate##>',CONVERT(VARCHAR,GETDATE(),103))
	FROM
		[metadata].[ScriptParts]
	WHERE
		[ScriptName] = 'UseDatabase'
	
	IF @DebugMode = 1 EXEC [dbo].[usp_PrintBig] @USQL

END
GO
/****** Object:  StoredProcedure [metadata].[ResetAllMetaData]    Script Date: 15/05/2018 09:43:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [metadata].[ResetAllMetaData]
AS

BEGIN
	
	TRUNCATE TABLE [metadata].[Mappings]
	DELETE FROM [metadata].[Attributes]
	DELETE FROM [metadata].[Objects]
	DELETE FROM [metadata].[ObjectTypes]
	DELETE FROM [metadata].[Systems]
	DELETE FROM [metadata].[SystemTechnologies]

	INSERT INTO [metadata].[SystemTechnologies]	([TechnologyName])
	VALUES 
		('Unknown'),
		('File'),
		('Database'),
		('ODBC')

	INSERT INTO [metadata].[ObjectTypes]
		(
	    [ObjectTypeName]
		)
	VALUES
		('Unknown'),
		('csv'),
		('txt'),
		('tsv'),
		('table')


END
GO
EXEC sys.sp_addextendedproperty @name=N'microsoft_database_tools_support', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'sysdiagrams'
GO
USE [master]
GO
ALTER DATABASE [sdbamsdapdev001] SET  READ_WRITE 
GO

USE [sdbamsdapdev001]
GO
/****** Object:  Table [metadata].[Attributes]    Script Date: 06/06/2018 14:51:14 ******/
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
ALTER TABLE [metadata].[Attributes]  WITH CHECK ADD  CONSTRAINT [FK_Attributes_Objects] FOREIGN KEY([ObjectId])
REFERENCES [metadata].[Objects] ([ObjectId])
GO
ALTER TABLE [metadata].[Attributes] CHECK CONSTRAINT [FK_Attributes_Objects]
GO

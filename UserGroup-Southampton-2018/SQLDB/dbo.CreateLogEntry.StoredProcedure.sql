USE [sdbamsdapdev001]
GO
/****** Object:  StoredProcedure [dbo].[CreateLogEntry]    Script Date: 06/06/2018 14:51:14 ******/
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

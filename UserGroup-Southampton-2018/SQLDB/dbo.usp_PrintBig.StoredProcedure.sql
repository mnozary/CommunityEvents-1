USE [sdbamsdapdev001]
GO
/****** Object:  StoredProcedure [dbo].[usp_PrintBig]    Script Date: 06/06/2018 14:51:14 ******/
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

USE powerlifting_db;
GO
EXEC sp_help 'dbo.openpowerlifting';
GO

-- Log tablosu yoksa olu�tur
IF OBJECT_ID('dbo.SchemaChangesLog', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.SchemaChangesLog (
        LogID INT IDENTITY(1,1) PRIMARY KEY,   
        EventTime DATETIME DEFAULT GETDATE(),   
        EventType NVARCHAR(100),            
        ObjectSchema NVARCHAR(100) NULL,       
        ObjectName NVARCHAR(100) NULL,         
        TSQLCommand NVARCHAR(MAX),              
        LoginName NVARCHAR(100)         
    );
    PRINT 'dbo.SchemaChangesLog tablosu olu�turuldu.';
END
ELSE
BEGIN
    PRINT 'dbo.SchemaChangesLog tablosu zaten mevcut.';
END
GO

-- Tetikleyici zaten varsa sil (script'in tekrar �al��t�r�labilir olmas� i�in)
IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'trg_LogSchemaChanges' AND parent_class_desc = 'DATABASE')
BEGIN
    DROP TRIGGER trg_LogSchemaChanges ON DATABASE;
    PRINT 'Mevcut trg_LogSchemaChanges DDL tetikleyicisi silindi.';
END
GO

-- Yeni DDL tetikleyicisini olu�tur
CREATE TRIGGER trg_LogSchemaChanges
ON DATABASE
FOR DDL_TABLE_EVENTS, DDL_INDEX_EVENTS

AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @EventData XML = EVENTDATA();
    DECLARE @EventType NVARCHAR(100);
    DECLARE @ObjectSchema NVARCHAR(100);
    DECLARE @ObjectName NVARCHAR(100);
    DECLARE @TSQLCommand NVARCHAR(MAX);
    DECLARE @LoginName NVARCHAR(100);

    SET @EventType = @EventData.value('(/EVENT_INSTANCE/EventType)[1]', 'NVARCHAR(100)');
    SET @ObjectSchema = @EventData.value('(/EVENT_INSTANCE/SchemaName)[1]', 'NVARCHAR(100)');
    SET @ObjectName = @EventData.value('(/EVENT_INSTANCE/ObjectName)[1]', 'NVARCHAR(100)');
    SET @TSQLCommand = @EventData.value('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]', 'NVARCHAR(MAX)');
    SET @LoginName = @EventData.value('(/EVENT_INSTANCE/LoginName)[1]', 'NVARCHAR(100)');
	
    INSERT INTO dbo.SchemaChangesLog
        (EventType, ObjectSchema, ObjectName, TSQLCommand, LoginName)
    VALUES
        (@EventType, @ObjectSchema, @ObjectName, @TSQLCommand, @LoginName);

END;
GO

PRINT 'trg_LogSchemaChanges DDL tetikleyicisi ba�ar�yla olu�turuldu/g�ncellendi.';
GO

-- Tetikleyiciyi test etmek i�in basit bir tablo olu�tur
CREATE TABLE dbo.TestTableForDDL (
    TestID INT PRIMARY KEY,
    TestData VARCHAR(50)
);
GO

PRINT 'dbo.TestTableForDDL tablosu test amac�yla olu�turuldu.';
GO

-- Log tablosundaki kay�tlar� g�ster (en sonuncular �stte)
SELECT TOP 5 -- Son 5 kayd� g�sterelim
    LogID,
    EventTime,
    EventType,
    ObjectSchema,
    ObjectName,
    LoginName,
    TSQLCommand
FROM
    dbo.SchemaChangesLog
ORDER BY
    EventTime DESC;
GO

-- Test tablosunu sil
IF OBJECT_ID('dbo.TestTableForDDL', 'U') IS NOT NULL
BEGIN
    DROP TABLE dbo.TestTableForDDL;
    PRINT 'dbo.TestTableForDDL tablosu test amac�yla silindi.';
END
ELSE
BEGIN
    PRINT 'dbo.TestTableForDDL tablosu bulunamad�.';
END
GO

-- Log tablosundaki kay�tlar� tekrar g�ster (en sonuncular �stte)
SELECT TOP 5
    LogID,
    EventTime,
    EventType,
    ObjectSchema,
    ObjectName,
    LoginName,
    TSQLCommand
FROM
    dbo.SchemaChangesLog
ORDER BY
    EventTime DESC;
GO
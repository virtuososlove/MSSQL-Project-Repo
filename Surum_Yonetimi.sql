USE powerlifting_db;
GO
EXEC sp_help 'dbo.openpowerlifting';
GO

-- Log tablosu yoksa oluþtur
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
    PRINT 'dbo.SchemaChangesLog tablosu oluþturuldu.';
END
ELSE
BEGIN
    PRINT 'dbo.SchemaChangesLog tablosu zaten mevcut.';
END
GO

-- Tetikleyici zaten varsa sil (script'in tekrar çalýþtýrýlabilir olmasý için)
IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'trg_LogSchemaChanges' AND parent_class_desc = 'DATABASE')
BEGIN
    DROP TRIGGER trg_LogSchemaChanges ON DATABASE;
    PRINT 'Mevcut trg_LogSchemaChanges DDL tetikleyicisi silindi.';
END
GO

-- Yeni DDL tetikleyicisini oluþtur
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

PRINT 'trg_LogSchemaChanges DDL tetikleyicisi baþarýyla oluþturuldu/güncellendi.';
GO

-- Tetikleyiciyi test etmek için basit bir tablo oluþtur
CREATE TABLE dbo.TestTableForDDL (
    TestID INT PRIMARY KEY,
    TestData VARCHAR(50)
);
GO

PRINT 'dbo.TestTableForDDL tablosu test amacýyla oluþturuldu.';
GO

-- Log tablosundaki kayýtlarý göster (en sonuncular üstte)
SELECT TOP 5 -- Son 5 kaydý gösterelim
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
    PRINT 'dbo.TestTableForDDL tablosu test amacýyla silindi.';
END
ELSE
BEGIN
    PRINT 'dbo.TestTableForDDL tablosu bulunamadý.';
END
GO

-- Log tablosundaki kayýtlarý tekrar göster (en sonuncular üstte)
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
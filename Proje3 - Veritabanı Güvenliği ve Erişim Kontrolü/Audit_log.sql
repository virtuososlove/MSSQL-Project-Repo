--Audit'i aktif etme ve çalýþtýrma kýsmý
--Audit nesnesi oluþturma
USE master;
GO
IF NOT EXISTS (SELECT * FROM sys.server_audits WHERE name = 'OrnekDB_Audit')
BEGIN
    CREATE SERVER AUDIT OrnekDB_Audit
    TO FILE (FILEPATH = 'C:\test\')
    WITH (QUEUE_DELAY = 1000, ON_FAILURE = CONTINUE);
     PRINT 'Audit nesnesi oluþturuldu.';
END
ELSE
BEGIN
     PRINT 'Audit nesnesi "OrnekDB_Audit" zaten var.';
END
GO
--Audit nesnesini aktif etme
USE master;
GO
IF EXISTS (SELECT * FROM sys.server_audits WHERE name = 'OrnekDB_Audit' AND is_state_enabled = 0)
BEGIN
    ALTER SERVER AUDIT OrnekDB_Audit WITH (STATE = ON);
    PRINT 'Audit nesnesi etkinleþtirildi.';
END
ELSE IF EXISTS (SELECT * FROM sys.server_audits WHERE name = 'OrnekDB_Audit' AND is_state_enabled = 1)
BEGIN
     PRINT 'Audit nesnesi zaten etkin durumda.';
END
ELSE
BEGIN
     PRINT 'HATA: OrnekDB_Audit isimli Audit nesnesi bulunamadý!';
END
GO

USE WideWorldImporters; 
GO
-- Yeni spesifikasyonu oluþturalým
IF EXISTS (SELECT * FROM sys.database_audit_specifications WHERE name = 'OrnekDB_Audit_Spec')
BEGIN
     ALTER DATABASE AUDIT SPECIFICATION OrnekDB_Audit_Spec WITH (STATE = OFF);
     DROP DATABASE AUDIT SPECIFICATION OrnekDB_Audit_Spec;
     PRINT 'Mevcut "OrnekDB_Audit_Spec" spesifikasyonu silindi.';
END

CREATE DATABASE AUDIT SPECIFICATION OrnekDB_Audit_Spec
FOR SERVER AUDIT OrnekDB_Audit

ADD (SELECT ON OBJECT::Website.Customers BY OrnekSqlKullanici_User),
ADD (DELETE ON OBJECT::Sales.CustomerCategories BY public)
WITH (STATE = OFF);
GO

-- Spesifikasyonun etkin olup olmadýðýný kontrol edip deðilse etkinleþtirelim
IF EXISTS (SELECT * FROM sys.database_audit_specifications WHERE name = 'OrnekDB_Audit_Spec' AND is_state_enabled = 0)
BEGIN
    ALTER DATABASE AUDIT SPECIFICATION OrnekDB_Audit_Spec WITH (STATE = ON);
    PRINT 'Veritabaný Audit Spesifikasyonu etkinleþtirildi.';
END
ELSE IF EXISTS (SELECT * FROM sys.database_audit_specifications WHERE name = 'OrnekDB_Audit_Spec' AND is_state_enabled = 1)
BEGIN
    PRINT 'Veritabaný Audit Spesifikasyonu zaten etkin durumda.';
END
ELSE
BEGIN
     PRINT 'HATA: OrnekDB_Audit_Spec isimli spesifikasyon bulunamadý!';
END
GO


--Audit loglanmasýný saðlamak için SELECT VE DELETE KULLANIMI
EXECUTE AS USER = 'OrnekSqlKullanici_User';

SELECT TOP 1 CustomerID, CustomerName FROM Website.Customers;

REVERT;
GO

DECLARE @TestCategoryName NVARCHAR(50) = 'Silinecek Denetim Kategorisi';

IF NOT EXISTS (SELECT 1 FROM Sales.CustomerCategories WHERE CustomerCategoryName = @TestCategoryName)
BEGIN
    INSERT INTO Sales.CustomerCategories (CustomerCategoryName, LastEditedBy) VALUES (@TestCategoryName, 1);
    PRINT @TestCategoryName + ' eklendi.';
END
ELSE
BEGIN
     PRINT @TestCategoryName + ' zaten vardý.';
END

PRINT @TestCategoryName + ' siliniyor...';
DELETE FROM Sales.CustomerCategories
WHERE CustomerCategoryName = @TestCategoryName;

IF @@ROWCOUNT > 0
     PRINT 'Test kategorisi silindi (Bu DELETE loglanmýþ olmalý).';
ELSE
     PRINT 'Silinecek test kategorisi bulunamadý.';
GO

--audit loglarýnýn kontorlü
SELECT
    event_time,
    action_id,
    succeeded,
    session_server_principal_name AS LoginName,
    database_principal_name AS DatabaseUserName,
    server_instance_name AS ServerName,
    database_name AS DatabaseName,
    schema_name AS SchemaName,
    object_name AS ObjectName,
    statement AS SqlStatement -- Çalýþtýrýlan sorgu
FROM
    sys.fn_get_audit_file ('C:\test\OrnekDB_Audit_*.sqlaudit', default, default);
GO
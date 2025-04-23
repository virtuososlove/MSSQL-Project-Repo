
--Veritabaný Rollerini Oluþturma
USE AdventureWorksDW2022;
GO

CREATE ROLE AnalystReadOnly;
GO

CREATE ROLE ETLOperator;
GO


--Rollere Ýzinleri Atama

USE AdventureWorksDW2022;
GO

-- AnalystReadOnly rolüne dbo þemasýndaki nesneler üzerinde SELECT izni verme
GRANT SELECT ON SCHEMA::dbo TO AnalystReadOnly;
GO

-- ETLOperator rolüne dbo þemasýndaki nesneler üzerinde SELECT, INSERT, UPDATE, DELETE izinleri verme
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::dbo TO ETLOperator;
GO




-- Kullanýcýlarý Rollere Atama

CREATE LOGIN SampleAnalystLogin WITH PASSWORD = 'YourStrongPasswordHere';
GO


CREATE LOGIN SampleETLLogin WITH PASSWORD = 'YourStrongPasswordHere';
GO



USE AdventureWorksDW2022;
GO

CREATE USER SampleAnalystUser FOR LOGIN SampleAnalystLogin;
GO


CREATE USER SampleETLUser FOR LOGIN SampleETLLogin;
GO

ALTER ROLE AnalystReadOnly ADD MEMBER SampleAnalystUser;
GO

ALTER ROLE ETLOperator ADD MEMBER SampleETLUser;
GO

PRINT 'Örnek Loginler, Userlar oluþturuldu ve ilgili rollere atandý.';

--Veritaban� Rollerini Olu�turma
USE AdventureWorksDW2022;
GO

CREATE ROLE AnalystReadOnly;
GO

CREATE ROLE ETLOperator;
GO


--Rollere �zinleri Atama

USE AdventureWorksDW2022;
GO

-- AnalystReadOnly rol�ne dbo �emas�ndaki nesneler �zerinde SELECT izni verme
GRANT SELECT ON SCHEMA::dbo TO AnalystReadOnly;
GO

-- ETLOperator rol�ne dbo �emas�ndaki nesneler �zerinde SELECT, INSERT, UPDATE, DELETE izinleri verme
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::dbo TO ETLOperator;
GO




-- Kullan�c�lar� Rollere Atama

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

PRINT '�rnek Loginler, Userlar olu�turuldu ve ilgili rollere atand�.';
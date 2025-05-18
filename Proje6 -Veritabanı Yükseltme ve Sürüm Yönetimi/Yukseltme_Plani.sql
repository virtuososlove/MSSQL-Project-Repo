-- Mevcut SQL Server örneðinin sürüm bilgilerini al
SELECT @@VERSION AS SQLServerVersionInfo;
GO

-- 'powerlifting_db' veritabanýnýn uyumluluk seviyesini kontrol et
USE master;
GO
SELECT compatibility_level
FROM sys.databases
WHERE name = N'powerlifting_db';
GO

-- 'powerlifting_db' veritabanýnýn boyutunu göster
USE powerlifting_db;
GO
EXEC sp_spaceused;
GO

USE powerlifting_db;
GO
-- Kullanýcý tablolarýný listele
SELECT TABLE_SCHEMA, TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE' AND TABLE_SCHEMA <> 'sys';

-- View'larý listele
SELECT TABLE_SCHEMA, TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'VIEW' AND TABLE_SCHEMA <> 'sys';

-- Stored Procedure'larý listele
SELECT SPECIFIC_SCHEMA, SPECIFIC_NAME
FROM INFORMATION_SCHEMA.ROUTINES
WHERE ROUTINE_TYPE = 'PROCEDURE' AND SPECIFIC_SCHEMA <> 'sys';

-- Fonksiyonlarý listele
SELECT SPECIFIC_SCHEMA, SPECIFIC_NAME, ROUTINE_TYPE
FROM INFORMATION_SCHEMA.ROUTINES
WHERE ROUTINE_TYPE IN ('FUNCTION', 'TABLE_FUNCTION') AND SPECIFIC_SCHEMA <> 'sys';
GO

-- Geliþmiþ seçenekleri göstermeyi etkinleþtir
EXEC sp_configure 'show advanced options', 1;
RECONFIGURE; 
GO

-- Mevcut tüm yapýlandýrma ayarlarýný ve deðerlerini listele
EXEC sp_configure;
GO
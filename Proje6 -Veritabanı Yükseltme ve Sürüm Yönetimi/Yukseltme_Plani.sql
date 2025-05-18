-- Mevcut SQL Server �rne�inin s�r�m bilgilerini al
SELECT @@VERSION AS SQLServerVersionInfo;
GO

-- 'powerlifting_db' veritaban�n�n uyumluluk seviyesini kontrol et
USE master;
GO
SELECT compatibility_level
FROM sys.databases
WHERE name = N'powerlifting_db';
GO

-- 'powerlifting_db' veritaban�n�n boyutunu g�ster
USE powerlifting_db;
GO
EXEC sp_spaceused;
GO

USE powerlifting_db;
GO
-- Kullan�c� tablolar�n� listele
SELECT TABLE_SCHEMA, TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE' AND TABLE_SCHEMA <> 'sys';

-- View'lar� listele
SELECT TABLE_SCHEMA, TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'VIEW' AND TABLE_SCHEMA <> 'sys';

-- Stored Procedure'lar� listele
SELECT SPECIFIC_SCHEMA, SPECIFIC_NAME
FROM INFORMATION_SCHEMA.ROUTINES
WHERE ROUTINE_TYPE = 'PROCEDURE' AND SPECIFIC_SCHEMA <> 'sys';

-- Fonksiyonlar� listele
SELECT SPECIFIC_SCHEMA, SPECIFIC_NAME, ROUTINE_TYPE
FROM INFORMATION_SCHEMA.ROUTINES
WHERE ROUTINE_TYPE IN ('FUNCTION', 'TABLE_FUNCTION') AND SPECIFIC_SCHEMA <> 'sys';
GO

-- Geli�mi� se�enekleri g�stermeyi etkinle�tir
EXEC sp_configure 'show advanced options', 1;
RECONFIGURE; 
GO

-- Mevcut t�m yap�land�rma ayarlar�n� ve de�erlerini listele
EXEC sp_configure;
GO
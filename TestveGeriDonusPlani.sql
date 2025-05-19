USE powerlifting_db;
GO

-- Mevcut veritaban� ad�n� ve login ad�n� g�ster
SELECT DB_NAME() AS CurrentDatabase;
SELECT SUSER_SNAME() AS CurrentLogin;
SELECT USER_NAME() AS CurrentUser;
GO

-- 1. Test Tablosu Olu�turma (CREATE)
PRINT 'Ad�m 3.1.2: Fonksiyonel Test Ba�l�yor...';
IF OBJECT_ID('dbo.TestCRUD', 'U') IS NOT NULL DROP TABLE dbo.TestCRUD; -- Varsa �nce sil
CREATE TABLE dbo.TestCRUD (ID INT PRIMARY KEY, TestValue VARCHAR(10));
PRINT 'dbo.TestCRUD tablosu olu�turuldu.';
GO

-- 2. Veri Ekleme (INSERT)
INSERT INTO dbo.TestCRUD (ID, TestValue) VALUES (1, 'Test A');
PRINT '1 sat�r dbo.TestCRUD tablosuna eklendi.';
GO

-- 3. Veri Okuma (SELECT)
PRINT 'Eklenen veri okunuyor:';
SELECT ID, TestValue FROM dbo.TestCRUD WHERE ID = 1;
GO

-- 4. Veri G�ncelleme (UPDATE)
UPDATE dbo.TestCRUD SET TestValue = 'Test B' WHERE ID = 1;
PRINT '1 sat�r dbo.TestCRUD tablosunda g�ncellendi.';
GO

-- 5. G�ncellenmi� Veriyi Okuma (SELECT)
PRINT 'G�ncellenen veri okunuyor:';
SELECT ID, TestValue FROM dbo.TestCRUD WHERE ID = 1;
GO

-- 6. Veri Silme (DELETE)
DELETE FROM dbo.TestCRUD WHERE ID = 1;
PRINT '1 sat�r dbo.TestCRUD tablosundan silindi.';
GO

-- 7. Tabloyu Silme (DROP)
DROP TABLE dbo.TestCRUD;
PRINT 'dbo.TestCRUD tablosu silindi.';
PRINT 'Ad�m 3.1.2: Fonksiyonel Test Tamamland�.';
GO

-- Veritaban� b�t�nl���n� kontrol et (Sadece hatalar� g�ster)
DBCC CHECKDB ('powerlifting_db') WITH NO_INFOMSGS;
GO
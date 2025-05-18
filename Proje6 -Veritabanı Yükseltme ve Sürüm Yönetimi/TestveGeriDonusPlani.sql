USE powerlifting_db;
GO

-- Mevcut veritabaný adýný ve login adýný göster
SELECT DB_NAME() AS CurrentDatabase;
SELECT SUSER_SNAME() AS CurrentLogin;
SELECT USER_NAME() AS CurrentUser;
GO

-- 1. Test Tablosu Oluþturma (CREATE)
PRINT 'Adým 3.1.2: Fonksiyonel Test Baþlýyor...';
IF OBJECT_ID('dbo.TestCRUD', 'U') IS NOT NULL DROP TABLE dbo.TestCRUD; -- Varsa önce sil
CREATE TABLE dbo.TestCRUD (ID INT PRIMARY KEY, TestValue VARCHAR(10));
PRINT 'dbo.TestCRUD tablosu oluþturuldu.';
GO

-- 2. Veri Ekleme (INSERT)
INSERT INTO dbo.TestCRUD (ID, TestValue) VALUES (1, 'Test A');
PRINT '1 satýr dbo.TestCRUD tablosuna eklendi.';
GO

-- 3. Veri Okuma (SELECT)
PRINT 'Eklenen veri okunuyor:';
SELECT ID, TestValue FROM dbo.TestCRUD WHERE ID = 1;
GO

-- 4. Veri Güncelleme (UPDATE)
UPDATE dbo.TestCRUD SET TestValue = 'Test B' WHERE ID = 1;
PRINT '1 satýr dbo.TestCRUD tablosunda güncellendi.';
GO

-- 5. Güncellenmiþ Veriyi Okuma (SELECT)
PRINT 'Güncellenen veri okunuyor:';
SELECT ID, TestValue FROM dbo.TestCRUD WHERE ID = 1;
GO

-- 6. Veri Silme (DELETE)
DELETE FROM dbo.TestCRUD WHERE ID = 1;
PRINT '1 satýr dbo.TestCRUD tablosundan silindi.';
GO

-- 7. Tabloyu Silme (DROP)
DROP TABLE dbo.TestCRUD;
PRINT 'dbo.TestCRUD tablosu silindi.';
PRINT 'Adým 3.1.2: Fonksiyonel Test Tamamlandý.';
GO

-- Veritabaný bütünlüðünü kontrol et (Sadece hatalarý göster)
DBCC CHECKDB ('powerlifting_db') WITH NO_INFOMSGS;
GO
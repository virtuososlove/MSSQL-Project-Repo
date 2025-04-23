-- Windows Login için Veritabaný Kullanýcýsý Oluþturma
USE WideWorldImporters;
GO

CREATE USER Melih_User FOR LOGIN [DESKTOP\Melih];
GO

SELECT
    name AS VeritabaniKullaniciAdi,
    type_desc AS KullaniciTipi, 
    authentication_type_desc AS KimlikDogrulamaTipi
FROM
    sys.database_principals
WHERE
    name = 'Melih_User';
GO

GRANT SELECT ON Application.People TO Melih_User;
GO

SELECT
    princ.name AS KullaniciAdi,
    perm.permission_name AS Yetki,
    perm.state_desc AS YetkiDurumu,
    obj.name AS NesneAdi,
    sch.name AS SemaAdi
FROM
    sys.database_permissions AS perm
INNER JOIN
    sys.database_principals AS princ ON perm.grantee_principal_id = princ.principal_id
INNER JOIN
    sys.objects AS obj ON perm.major_id = obj.object_id
INNER JOIN
    sys.schemas AS sch ON obj.schema_id = sch.schema_id
WHERE
    princ.name = 'Melih_User' AND obj.name = 'People';
GO

-- yetkinin testi için deneme sorgularý
-- izin verilen sorgu
SELECT TOP 5 PersonID, FullName FROM Application.People;
GO
-- izin verilmeyen sorgu
SELECT TOP 5 CustomerID, CustomerName FROM Website.Customers;
GO
-- izin verilmeyen sorgu
SELECT TOP 5 OrderID FROM Sales.Orders;
GO


--Mevcut PC admin hesabýmýz tüm yetkilere sahip olduðu için kýsýtlamalar geçersiz kaldý
SELECT IS_ROLEMEMBER('db_owner', N'Melih_User') AS IsDbOwner;

SELECT IS_SRVROLEMEMBER('sysadmin', N'DESKTOP-OS7IBMJ\Melih') AS IsSysAdmin;


--Baþka bir kullanýcýnýn yerine geçerek onun yetkilerine dayalý çalýþtýrma denemesi
EXECUTE AS USER = 'Melih_User';

-- Bu sorgu çalýþmalý
PRINT 'Application.People sorgusu deneniyor (Baþarýlý olmalý):';
SELECT TOP 5 PersonID, FullName FROM Application.People;

-- Bu sorgu HATA VERMELÝ
PRINT 'Website.Customers sorgusu deneniyor (Hata vermeli):';
BEGIN TRY
    SELECT TOP 5 CustomerID, CustomerName FROM Website.Customers;
    PRINT '>> BEKLENMEYEN BAÞARI: Website.Customers sorgusu çalýþtý!';
END TRY
BEGIN CATCH
    PRINT '>> BEKLENEN HATA ALINDI: ' + ERROR_MESSAGE();
END CATCH
REVERT;
GO

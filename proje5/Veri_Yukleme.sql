USE WideWorldImporters;
GO

--Y�ll�k M��teri �zeti Tablosunu Olu�turma ve Y�kleme
-- Hedef tablo yoksa olu�tur
IF OBJECT_ID('Sales.CustomerSummaryByYear', 'U') IS NULL
BEGIN
    CREATE TABLE Sales.CustomerSummaryByYear (
        AcilisYili INT PRIMARY KEY,
        MusteriSayisi INT
    );
    PRINT 'Sales.CustomerSummaryByYear tablosu olu�turuldu.';
END
ELSE
BEGIN
    PRINT 'Sales.CustomerSummaryByYear tablosu zaten mevcut. Tekrar olu�turulmayacak.';
END
GO

-- Y�kleme �ncesi tabloyu temizleme i�lemi
IF OBJECT_ID('Sales.CustomerSummaryByYear', 'U') IS NOT NULL
BEGIN
     TRUNCATE TABLE Sales.CustomerSummaryByYear;
END
GO

-- Hesaplanan �zet veriyi Sales.CustomerSummaryByYear tablosuna y�kleme i�lemi
INSERT INTO Sales.CustomerSummaryByYear (AcilisYili, MusteriSayisi)
SELECT
    YEAR(AccountOpenedDate) AS HesapAcilisYili,
    COUNT(*) AS MusteriSayisi
FROM
    Sales.Customers
GROUP BY
    YEAR(AccountOpenedDate);
GO

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' sat�r Sales.CustomerSummaryByYear tablosuna y�klendi.';
GO

-- Yeni y�klenen tablodaki verileri g�ster
SELECT
    AcilisYili,
    MusteriSayisi
FROM
    Sales.CustomerSummaryByYear
ORDER BY
    AcilisYili;
GO




--Tam Teslimat Adreslerini Yeni Tabloya Y�kleme

-- Hedef tablo yoksa olu�tur
IF OBJECT_ID('Sales.CustomerFullDeliveryAddress', 'U') IS NULL
BEGIN
    CREATE TABLE Sales.CustomerFullDeliveryAddress (
        CustomerID INT PRIMARY KEY,        
        TamTeslimatAdresi NVARCHAR(500) NULL
    );
    PRINT 'Sales.CustomerFullDeliveryAddress tablosu olu�turuldu.';
END
ELSE
BEGIN
    PRINT 'Sales.CustomerFullDeliveryAddress tablosu zaten mevcut. Tekrar olu�turulmayacak.';
END
GO

-- Y�kleme �ncesi tabloyu temizle
IF OBJECT_ID('Sales.CustomerFullDeliveryAddress', 'U') IS NOT NULL
BEGIN
     TRUNCATE TABLE Sales.CustomerFullDeliveryAddress;
END
GO

-- Birle�tirilmi� adres verisini yeni tabloya y�kle
INSERT INTO Sales.CustomerFullDeliveryAddress (CustomerID, TamTeslimatAdresi)
SELECT
    C.CustomerID,
    CONCAT(
        C.DeliveryAddressLine1,
        CASE WHEN C.DeliveryAddressLine2 IS NOT NULL AND C.DeliveryAddressLine2 <> '' THEN N', ' + C.DeliveryAddressLine2 ELSE N'' END,
        N', ', CT.CityName,
        N', ', SP.StateProvinceName,
        N' ', C.DeliveryPostalCode
    )
FROM
    Sales.Customers AS C
INNER JOIN
    Application.Cities AS CT ON C.DeliveryCityID = CT.CityID
INNER JOIN
    Application.StateProvinces AS SP ON CT.StateProvinceID = SP.StateProvinceID;
GO

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' sat�r Sales.CustomerFullDeliveryAddress tablosuna y�klendi.';
GO

-- Yeni y�klenen tablodaki ilk 10 veriyi g�ster
SELECT TOP 10
    CustomerID,
    TamTeslimatAdresi
FROM
    Sales.CustomerFullDeliveryAddress
ORDER BY
    CustomerID;
GO
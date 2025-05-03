USE WideWorldImporters;
GO

--Yýllýk Müþteri Özeti Tablosunu Oluþturma ve Yükleme
-- Hedef tablo yoksa oluþtur
IF OBJECT_ID('Sales.CustomerSummaryByYear', 'U') IS NULL
BEGIN
    CREATE TABLE Sales.CustomerSummaryByYear (
        AcilisYili INT PRIMARY KEY,
        MusteriSayisi INT
    );
    PRINT 'Sales.CustomerSummaryByYear tablosu oluþturuldu.';
END
ELSE
BEGIN
    PRINT 'Sales.CustomerSummaryByYear tablosu zaten mevcut. Tekrar oluþturulmayacak.';
END
GO

-- Yükleme öncesi tabloyu temizleme iþlemi
IF OBJECT_ID('Sales.CustomerSummaryByYear', 'U') IS NOT NULL
BEGIN
     TRUNCATE TABLE Sales.CustomerSummaryByYear;
END
GO

-- Hesaplanan özet veriyi Sales.CustomerSummaryByYear tablosuna yükleme iþlemi
INSERT INTO Sales.CustomerSummaryByYear (AcilisYili, MusteriSayisi)
SELECT
    YEAR(AccountOpenedDate) AS HesapAcilisYili,
    COUNT(*) AS MusteriSayisi
FROM
    Sales.Customers
GROUP BY
    YEAR(AccountOpenedDate);
GO

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' satýr Sales.CustomerSummaryByYear tablosuna yüklendi.';
GO

-- Yeni yüklenen tablodaki verileri göster
SELECT
    AcilisYili,
    MusteriSayisi
FROM
    Sales.CustomerSummaryByYear
ORDER BY
    AcilisYili;
GO




--Tam Teslimat Adreslerini Yeni Tabloya Yükleme

-- Hedef tablo yoksa oluþtur
IF OBJECT_ID('Sales.CustomerFullDeliveryAddress', 'U') IS NULL
BEGIN
    CREATE TABLE Sales.CustomerFullDeliveryAddress (
        CustomerID INT PRIMARY KEY,        
        TamTeslimatAdresi NVARCHAR(500) NULL
    );
    PRINT 'Sales.CustomerFullDeliveryAddress tablosu oluþturuldu.';
END
ELSE
BEGIN
    PRINT 'Sales.CustomerFullDeliveryAddress tablosu zaten mevcut. Tekrar oluþturulmayacak.';
END
GO

-- Yükleme öncesi tabloyu temizle
IF OBJECT_ID('Sales.CustomerFullDeliveryAddress', 'U') IS NOT NULL
BEGIN
     TRUNCATE TABLE Sales.CustomerFullDeliveryAddress;
END
GO

-- Birleþtirilmiþ adres verisini yeni tabloya yükle
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

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' satýr Sales.CustomerFullDeliveryAddress tablosuna yüklendi.';
GO

-- Yeni yüklenen tablodaki ilk 10 veriyi göster
SELECT TOP 10
    CustomerID,
    TamTeslimatAdresi
FROM
    Sales.CustomerFullDeliveryAddress
ORDER BY
    CustomerID;
GO
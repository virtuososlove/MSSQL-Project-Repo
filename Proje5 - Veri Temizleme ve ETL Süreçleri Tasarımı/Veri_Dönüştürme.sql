--Müþteri Ýsimlerini Büyük Harfe Dönüþtürme
USE WideWorldImporters;
GO

SELECT TOP 10
    CustomerID,
    CustomerName AS OrjinalIsim,
    UPPER(CustomerName) AS BuyukHarfIsim
FROM
    Sales.Customers;
GO

-- Sales.Customers tablosundaki CustomerName sütununu büyük harfe güncellenmesi
UPDATE Sales.Customers
SET CustomerName = UPPER(CustomerName);
GO

-- Güncellemenin etkisini görmek için ilk 10 kaydý tekrar seçilmesi
SELECT TOP 10
    CustomerID,
    CustomerName
FROM
    Sales.Customers;
GO

-- Müþterilerin teslimat adresi bileþenlerini birleþtirerek tam adresi oluþtur (Ýlk 10)
SELECT TOP 10
    C.CustomerID,
    C.CustomerName,
    CONCAT(
        C.DeliveryAddressLine1,
        CASE
            WHEN C.DeliveryAddressLine2 IS NOT NULL AND C.DeliveryAddressLine2 <> ''
            THEN N', ' + C.DeliveryAddressLine2
            ELSE N''
        END,
        N', ', CT.CityName,
        N', ', SP.StateProvinceName,
        N' ', C.DeliveryPostalCode
    ) AS TamTeslimatAdresi
FROM
    Sales.Customers AS C
INNER JOIN
    Application.Cities AS CT ON C.DeliveryCityID = CT.CityID
INNER JOIN
    Application.StateProvinces AS SP ON CT.StateProvinceID = SP.StateProvinceID;
GO

-- Müþterilerin hesap açýlýþ tarihinden yýl bilgisini çýkar (Ýlk 10)
SELECT TOP 10
    CustomerID,
    CustomerName,
    AccountOpenedDate,
    YEAR(AccountOpenedDate) AS HesapAcilisYili
FROM
    Sales.Customers
ORDER BY
    AccountOpenedDate;
GO
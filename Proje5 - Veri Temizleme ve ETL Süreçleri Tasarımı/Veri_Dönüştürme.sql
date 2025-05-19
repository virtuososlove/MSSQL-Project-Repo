--M��teri �simlerini B�y�k Harfe D�n��t�rme
USE WideWorldImporters;
GO

SELECT TOP 10
    CustomerID,
    CustomerName AS OrjinalIsim,
    UPPER(CustomerName) AS BuyukHarfIsim
FROM
    Sales.Customers;
GO

-- Sales.Customers tablosundaki CustomerName s�tununu b�y�k harfe g�ncellenmesi
UPDATE Sales.Customers
SET CustomerName = UPPER(CustomerName);
GO

-- G�ncellemenin etkisini g�rmek i�in ilk 10 kayd� tekrar se�ilmesi
SELECT TOP 10
    CustomerID,
    CustomerName
FROM
    Sales.Customers;
GO

-- M��terilerin teslimat adresi bile�enlerini birle�tirerek tam adresi olu�tur (�lk 10)
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

-- M��terilerin hesap a��l�� tarihinden y�l bilgisini ��kar (�lk 10)
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
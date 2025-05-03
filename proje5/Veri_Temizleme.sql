USE WideWorldImporters;
GO
--Eksik Birincil Kontak E-posta Adresine Sahip Müþterilerin Tespiti
SELECT
    C.CustomerID,
    C.CustomerName,
    P.PersonID AS PrimaryContactPersonID,
    P.FullName AS PrimaryContactName,
    P.EmailAddress AS PrimaryContactEmail
FROM
    Sales.Customers AS C
INNER JOIN
    Application.People AS P ON C.PrimaryContactPersonID = P.PersonID
WHERE
    P.EmailAddress IS NULL OR P.EmailAddress = '';
GO

-- Application.People tablosunda '@' içermeyen, NULL veya boþ olmayan e-posta adreslerini bul
SELECT
    PersonID,
    FullName,
    EmailAddress
FROM
    Application.People
WHERE
    EmailAddress IS NOT NULL        
    AND EmailAddress <> ''           
    AND EmailAddress NOT LIKE '%@%';
GO

-- Sales.Customers tablosunda PhoneNumber sütunu NULL veya boþ olan kayýtlarý bul
SELECT
    CustomerID,
    CustomerName,
    PhoneNumber
FROM
    Sales.Customers
WHERE
    PhoneNumber IS NULL OR PhoneNumber = '';
GO

-- Sales.Customers tablosunda CustomerName deðeri birden fazla geçen kayýtlarý bul
SELECT
    CustomerName,
    COUNT(*) AS KayitSayisi
FROM
    Sales.Customers
GROUP BY
    CustomerName
HAVING
    COUNT(*) > 1;
GO

-- FullName alanýnýn DATALENGTH'i ile LTRIM/RTRIM sonrasý DATALENGTH'i farklý olanlarý bul
SELECT
    PersonID,
    FullName,
    DATALENGTH(FullName) AS OrjinalDataUzunluk,
    DATALENGTH(LTRIM(RTRIM(FullName))) AS TemizDataUzunluk
FROM
    Application.People
WHERE
    DATALENGTH(FullName) <> DATALENGTH(LTRIM(RTRIM(FullName)));
GO

-- Baþýnda/sonunda boþluk olan FullName deðerlerini temizle
UPDATE Application.People
SET FullName = LTRIM(RTRIM(FullName))
WHERE
    DATALENGTH(FullName) <> DATALENGTH(LTRIM(RTRIM(FullName)));
GO

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' satýrýn FullName alaný baþ/son boþluklardan temizlendi.';
GO

-- Temizleme sonrasý KONTROL: DATALENGTH'leri farklý olan kayýt kontrolü
SELECT
    PersonID,
    FullName,
    DATALENGTH(FullName) AS OrjinalDataUzunluk,
    DATALENGTH(LTRIM(RTRIM(FullName))) AS TemizDataUzunluk
FROM
    Application.People
WHERE
    DATALENGTH(FullName) <> DATALENGTH(LTRIM(RTRIM(FullName)));
GO

-- Protokolü eksik (http:// veya https:// ile baþlamayan) URL'leri bul
SELECT
    CustomerID,
    CustomerName,
    WebsiteURL
FROM
    Sales.Customers
WHERE
    WebsiteURL IS NOT NULL            
    AND WebsiteURL <> ''               
    AND WebsiteURL NOT LIKE 'http://%' 
    AND WebsiteURL NOT LIKE 'https://%';
GO

--temizleme iþlemi yapýlabilecek sadece bir baþlýk bulabildik. Diðer baþlýklar zaten olmasý gerektiði gibiydi.
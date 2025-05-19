USE WideWorldImporters;
GO
--Eksik Birincil Kontak E-posta Adresine Sahip M��terilerin Tespiti
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

-- Application.People tablosunda '@' i�ermeyen, NULL veya bo� olmayan e-posta adreslerini bul
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

-- Sales.Customers tablosunda PhoneNumber s�tunu NULL veya bo� olan kay�tlar� bul
SELECT
    CustomerID,
    CustomerName,
    PhoneNumber
FROM
    Sales.Customers
WHERE
    PhoneNumber IS NULL OR PhoneNumber = '';
GO

-- Sales.Customers tablosunda CustomerName de�eri birden fazla ge�en kay�tlar� bul
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

-- FullName alan�n�n DATALENGTH'i ile LTRIM/RTRIM sonras� DATALENGTH'i farkl� olanlar� bul
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

-- Ba��nda/sonunda bo�luk olan FullName de�erlerini temizle
UPDATE Application.People
SET FullName = LTRIM(RTRIM(FullName))
WHERE
    DATALENGTH(FullName) <> DATALENGTH(LTRIM(RTRIM(FullName)));
GO

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' sat�r�n FullName alan� ba�/son bo�luklardan temizlendi.';
GO

-- Temizleme sonras� KONTROL: DATALENGTH'leri farkl� olan kay�t kontrol�
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

-- Protokol� eksik (http:// veya https:// ile ba�lamayan) URL'leri bul
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

--temizleme i�lemi yap�labilecek sadece bir ba�l�k bulabildik. Di�er ba�l�klar zaten olmas� gerekti�i gibiydi.
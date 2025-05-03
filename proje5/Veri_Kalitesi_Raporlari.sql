USE WideWorldImporters;
GO

-- Orijinal adres sat�rlar�n�n (Line1 + Line2) ortalama toplam uzunlu�unu veren sorgu
SELECT
    AVG(
        LEN(ISNULL(DeliveryAddressLine1, N''))
        + LEN(ISNULL(DeliveryAddressLine2, N''))
    ) AS OrtalamaOrijinalAdresUzunlugu
FROM
    Sales.Customers;
GO

-- Birle�tirilip y�klenen tam adreslerin ortalama uzunlu�unu veren sorgu
SELECT
    AVG(LEN(TamTeslimatAdresi)) AS OrtalamaBirlesikAdresUzunlugu
FROM
    Sales.CustomerFullDeliveryAddress;
GO

--Orijinal adres uzunlu�u birle�ik adres uzunlu�undan daha k�sa oldu�unu g�zlemlemi� olduk. Bu k�sma kadar yapm�� oldu�umuz 3 ad�mdaki i�lemler de yine veri kalitesini raporluyor. D�k�manda ilgili durumlar� belirttik.
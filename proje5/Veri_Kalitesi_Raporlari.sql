USE WideWorldImporters;
GO

-- Orijinal adres satýrlarýnýn (Line1 + Line2) ortalama toplam uzunluðunu veren sorgu
SELECT
    AVG(
        LEN(ISNULL(DeliveryAddressLine1, N''))
        + LEN(ISNULL(DeliveryAddressLine2, N''))
    ) AS OrtalamaOrijinalAdresUzunlugu
FROM
    Sales.Customers;
GO

-- Birleþtirilip yüklenen tam adreslerin ortalama uzunluðunu veren sorgu
SELECT
    AVG(LEN(TamTeslimatAdresi)) AS OrtalamaBirlesikAdresUzunlugu
FROM
    Sales.CustomerFullDeliveryAddress;
GO

--Orijinal adres uzunluðu birleþik adres uzunluðundan daha kýsa olduðunu gözlemlemiþ olduk. Bu kýsma kadar yapmýþ olduðumuz 3 adýmdaki iþlemler de yine veri kalitesini raporluyor. Dökümanda ilgili durumlarý belirttik.
--Login ve Yetkiyi Test Etme

--�zin verilen sorgu
USE WideWorldImporters;
SELECT TOP 5 CustomerID, CustomerName FROM Website.Customers;
GO

--�zin verilmeyen sorgu

USE WideWorldImporters;
SELECT TOP 5 FullName FROM Application.People;
GO
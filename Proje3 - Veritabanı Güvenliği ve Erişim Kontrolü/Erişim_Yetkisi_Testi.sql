--Login ve Yetkiyi Test Etme

--Ýzin verilen sorgu
USE WideWorldImporters;
SELECT TOP 5 CustomerID, CustomerName FROM Website.Customers;
GO

--Ýzin verilmeyen sorgu

USE WideWorldImporters;
SELECT TOP 5 FullName FROM Application.People;
GO
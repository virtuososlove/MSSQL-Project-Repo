USE WideWorldImporters;
GO

CREATE OR ALTER PROCEDURE dbo.FindCustomers_Vulnerable
    @CustomerNameFragment NVARCHAR(100)
AS
BEGIN
    DECLARE @SQL NVARCHAR(MAX);

    SET @SQL = 'SELECT CustomerID, CustomerName, PhoneNumber
                FROM Website.Customers
                WHERE CustomerName LIKE ''%' + @CustomerNameFragment + '%''';

    PRINT 'Calistirilacak SQL Metni: ' + @SQL;

    EXEC (@SQL);
END
GO

--normal çalýþtýrma denemesi
EXEC dbo.FindCustomers_Vulnerable @CustomerNameFragment = N'Tailspin';

--saldýrý simülasyonu
EXEC dbo.FindCustomers_Vulnerable @CustomerNameFragment = N''' OR 1=1 --';

-- Yönetici hesabýyla çalýþtýrýn
USE WideWorldImporters;
GO

PRINT 'Güvenli procedür "dbo.FindCustomers_Safe" oluþturuluyor...';
GO

--GÜVENLÝ YÖNTEM: Parametreli Sorgu
CREATE OR ALTER PROCEDURE dbo.FindCustomers_Safe
    @CustomerNameFragment NVARCHAR(100)
AS
BEGIN
    SELECT CustomerID, CustomerName, PhoneNumber
    FROM Website.Customers
    WHERE CustomerName LIKE '%' + @CustomerNameFragment + '%';
END
GO

--Tekrar ayný iþlemi test edelim
EXEC dbo.FindCustomers_Safe @CustomerNameFragment = N'Tailspin';

EXEC dbo.FindCustomers_Safe @CustomerNameFragment = N''' OR 1=1 --';

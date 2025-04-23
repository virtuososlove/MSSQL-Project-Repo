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

--normal �al��t�rma denemesi
EXEC dbo.FindCustomers_Vulnerable @CustomerNameFragment = N'Tailspin';

--sald�r� sim�lasyonu
EXEC dbo.FindCustomers_Vulnerable @CustomerNameFragment = N''' OR 1=1 --';

-- Y�netici hesab�yla �al��t�r�n
USE WideWorldImporters;
GO

PRINT 'G�venli proced�r "dbo.FindCustomers_Safe" olu�turuluyor...';
GO

--G�VENL� Y�NTEM: Parametreli Sorgu
CREATE OR ALTER PROCEDURE dbo.FindCustomers_Safe
    @CustomerNameFragment NVARCHAR(100)
AS
BEGIN
    SELECT CustomerID, CustomerName, PhoneNumber
    FROM Website.Customers
    WHERE CustomerName LIKE '%' + @CustomerNameFragment + '%';
END
GO

--Tekrar ayn� i�lemi test edelim
EXEC dbo.FindCustomers_Safe @CustomerNameFragment = N'Tailspin';

EXEC dbo.FindCustomers_Safe @CustomerNameFragment = N''' OR 1=1 --';

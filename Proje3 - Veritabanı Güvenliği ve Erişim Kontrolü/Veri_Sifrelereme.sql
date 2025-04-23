--S�tun �ifreleme Uygulamas�
USE WideWorldImporters;
GO

--Tabloya �ifreli S�tun Ekleme
IF COL_LENGTH('Sales.CustomerCategories', 'EncryptedCategoryName') IS NULL
BEGIN
    ALTER TABLE Sales.CustomerCategories
    ADD EncryptedCategoryName VARBINARY(MAX) NULL;
    PRINT 'EncryptedCategoryName s�tunu eklendi.';
END
ELSE
BEGIN
    PRINT 'EncryptedCategoryName s�tunu zaten var.';
END
GO

--Simetrik Anahtar Olu�turma
IF NOT EXISTS (SELECT * FROM sys.symmetric_keys WHERE name = 'CategoryName_SMKey')
BEGIN
    CREATE SYMMETRIC KEY CategoryName_SMKey
    WITH ALGORITHM = AES_256
    ENCRYPTION BY CERTIFICATE TDE_Cert;
    PRINT 'CategoryName_SMKey simetrik anahtar� olu�turuldu.';
END
ELSE
BEGIN
     PRINT 'CategoryName_SMKey simetrik anahtar� zaten var.';
END
GO

--Mevcut Veriyi �ifreleme
OPEN SYMMETRIC KEY CategoryName_SMKey
DECRYPTION BY CERTIFICATE TDE_Cert;

UPDATE Sales.CustomerCategories
SET EncryptedCategoryName = ENCRYPTBYKEY(KEY_GUID('CategoryName_SMKey'), CAST(CustomerCategoryName AS VARBINARY(8000)))
WHERE CustomerCategoryID <= 3 AND CustomerCategoryName IS NOT NULL;

CLOSE SYMMETRIC KEY CategoryName_SMKey;
GO


--�ifreli ve ��z�lm�� Veriyi G�r�nt�leme
OPEN SYMMETRIC KEY CategoryName_SMKey
DECRYPTION BY CERTIFICATE TDE_Cert;

SELECT
    CustomerCategoryID,
    CustomerCategoryName AS OrjinalKategoriAdi,
    EncryptedCategoryName AS SifreliVeri,
    CONVERT(NVARCHAR(50), DECRYPTBYKEY(EncryptedCategoryName)) AS CozulmusKategoriAdi
FROM Sales.CustomerCategories
WHERE CustomerCategoryID <= 3;

CLOSE SYMMETRIC KEY CategoryName_SMKey;
GO
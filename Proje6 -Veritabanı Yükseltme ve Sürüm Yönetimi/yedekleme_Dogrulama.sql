USE master;
GO
-- powerlifting_db veritabanýnýn tam yedeðini al
BACKUP DATABASE [powerlifting_db]
TO DISK = N'C:\SQLBackups\powerlifting_db_PreUpgrade_20250405_0246.bak'
WITH
    NAME = N'PowerliftingDB Pre-Upgrade Full Backup',
    DESCRIPTION = N'SQL Server yükseltmesi/güncellemesi öncesi alýnan tam yedek.',
    STATS = 10;
GO

USE master;
GO
-- Bir önceki adýmda alýnan yedek dosyasýnýn bütünlüðünü doðrula
RESTORE VERIFYONLY
FROM DISK = N'C:\SQLBackups\powerlifting_db_PreUpgrade_20250405_0246.bak'
-- WITH FILE = 1;
GO
USE master;
GO
-- powerlifting_db veritaban�n�n tam yede�ini al
BACKUP DATABASE [powerlifting_db]
TO DISK = N'C:\SQLBackups\powerlifting_db_PreUpgrade_20250405_0246.bak'
WITH
    NAME = N'PowerliftingDB Pre-Upgrade Full Backup',
    DESCRIPTION = N'SQL Server y�kseltmesi/g�ncellemesi �ncesi al�nan tam yedek.',
    STATS = 10;
GO

USE master;
GO
-- Bir �nceki ad�mda al�nan yedek dosyas�n�n b�t�nl���n� do�rula
RESTORE VERIFYONLY
FROM DISK = N'C:\SQLBackups\powerlifting_db_PreUpgrade_20250405_0246.bak'
-- WITH FILE = 1;
GO
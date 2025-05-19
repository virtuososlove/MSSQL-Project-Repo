SELECT name, recovery_model_desc
FROM sys.databases
WHERE name = 'powerlifting__db';
GO

BACKUP DATABASE powerlifting__db
TO DISK = N'C:\Backups\powerlifting_db_FULL_YENI_DENEME.bak'
WITH
    FORMAT,        
    INIT,         
    NAME = N'powerlifting_db - Yeni Deneme Full Backup',
    STATS = 10,
    CHECKSUM;     
GO

BACKUP LOG powerlifting__db
TO DISK = N'C:\Backups\powerlifting_db_LOG_YENI_DENEME.trn'
WITH
    FORMAT,
    INIT,
    NAME = N'powerlifting_db - Yeni Deneme Log Backup',
    STATS = 10,
    CHECKSUM;
GO
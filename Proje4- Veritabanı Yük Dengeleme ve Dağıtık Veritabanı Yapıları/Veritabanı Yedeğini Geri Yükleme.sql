RESTORE DATABASE powerlifting__db
FROM DISK = N'C:\Backups\powerlifting_db_FULL_YENI_DENEME.bak'
WITH
    MOVE N'powerlifting__db' TO N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER02\MSSQL\DATA\powerlifting__db.mdf',
    MOVE N'powerlifting__db_log' TO N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER02\MSSQL\DATA\powerlifting__db_log.ldf',
    NORECOVERY,
    NOUNLOAD,
    REPLACE,
    STATS = 10; 
GO

RESTORE LOG powerlifting__db
FROM DISK = N'C:\Backups\powerlifting_db_LOG_YENI_DENEME.trn'
WITH
    NORECOVERY,
    NOUNLOAD,
    STATS = 10;
GO
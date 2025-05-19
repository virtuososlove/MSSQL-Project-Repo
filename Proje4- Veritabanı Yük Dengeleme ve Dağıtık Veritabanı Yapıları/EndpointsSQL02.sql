IF NOT EXISTS (SELECT 1 FROM sys.database_mirroring_endpoints WHERE name = 'Mirroring_Endpoint_MSSQLSERVER02')
BEGIN
    CREATE ENDPOINT Mirroring_Endpoint_MSSQLSERVER02
    STATE = STARTED
    AS TCP (LISTENER_PORT = 5024, LISTENER_IP = ALL)
    FOR DATABASE_MIRRORING (
        ROLE = PARTNER,
        ENCRYPTION = REQUIRED ALGORITHM AES
    );
    PRINT 'Mirroring_Endpoint_MSSQLSERVER02 baþarýyla oluþturuldu veya zaten vardý.';
END
ELSE
BEGIN
    PRINT 'Mirroring_Endpoint_MSSQLSERVER02 zaten mevcut.';
END
GO

SELECT name, state_desc, role -- 
FROM sys.database_mirroring_endpoints
WHERE name = 'Mirroring_Endpoint_MSSQLSERVER02';
GO

SELECT name, state_desc, port
FROM sys.tcp_endpoints
WHERE type_desc = 'DATABASE_MIRRORING' AND name = 'Mirroring_Endpoint_MSSQLSERVER02';
GO





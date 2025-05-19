--MSSQLSERVER01
SELECT
    DB_NAME(database_id) AS DatabaseName,
    mirroring_role_desc AS Role,
    mirroring_state_desc AS State,
    mirroring_partner_name AS PartnerName,
    mirroring_partner_instance AS PartnerInstance,
    mirroring_witness_name AS WitnessName,
    mirroring_witness_state_desc AS WitnessState
FROM sys.database_mirroring
WHERE DB_NAME(database_id) = 'powerlifting__db';
GO

ALTER DATABASE powerlifting__db SET PARTNER FAILOVER;
GO

SELECT
    DB_NAME(database_id) AS DatabaseName,
    mirroring_role_desc AS Role,
    mirroring_state_desc AS State,
    mirroring_partner_name AS PartnerName,
    mirroring_partner_instance AS PartnerInstance,
    mirroring_witness_name AS WitnessName,
    mirroring_witness_state_desc AS WitnessState
FROM sys.database_mirroring
WHERE DB_NAME(database_id) = 'powerlifting__db';
GO

ALTER DATABASE powerlifting__db SET WITNESS = 'TCP://DESKTOP-OS7IBMJ\SQLEXPRESS:5025';
GO

SELECT
    DB_NAME(database_id) AS DatabaseName,
    mirroring_role_desc AS Role,
    mirroring_state_desc AS State,
    mirroring_partner_name AS PartnerName,
    mirroring_partner_instance AS PartnerInstance,
    mirroring_witness_name AS WitnessName,
    mirroring_witness_state_desc AS WitnessState
FROM sys.database_mirroring
WHERE DB_NAME(database_id) = 'powerlifting__db';
GO
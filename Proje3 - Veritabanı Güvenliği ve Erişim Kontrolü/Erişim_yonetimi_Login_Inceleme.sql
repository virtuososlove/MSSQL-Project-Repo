-- Mevcut Sunucu Girişlerini (Logins) İnceleme
SELECT
    name AS LoginAdi,         
    type_desc AS LoginTipi,   
    is_disabled,              
    create_date AS OlusturmaTarihi,
    default_database_name AS VarsayilanVeritabani
FROM
    sys.server_principals   
WHERE
    type IN ('U', 'G', 'S') 
    AND name NOT LIKE '##%'
ORDER BY
    LoginTipi,
    LoginAdi;

--Yeni Bir SQL Server Login Oluşturma
CREATE LOGIN OrnekSqlKullanici
WITH PASSWORD = 'Sifre123!',
DEFAULT_DATABASE = WideWorldImporters, 
CHECK_POLICY = ON,                    
CHECK_EXPIRATION = ON;                 
GO

---- Oluşturulan Login'i kontrol edelim
SELECT
    name AS LoginAdi,
    type_desc AS LoginTipi,
    default_database_name AS VarsayilanVeritabani
FROM
    sys.server_principals
WHERE
    name = 'OrnekSqlKullanici';
GO


--Veritabanı Kullanıcısı Oluşturma
CREATE USER OrnekSqlKullanici_User FOR LOGIN OrnekSqlKullanici;
GO

SELECT
    name AS VeritabaniKullaniciAdi,
    type_desc AS KullaniciTipi,        
    authentication_type_desc AS KimlikDogrulamaTipi
FROM
    sys.database_principals  
WHERE
    name = 'OrnekSqlKullanici_User';
GO

--Veritabanı Kullanıcısına Yetki Verme
GRANT SELECT ON Website.Customers TO OrnekSqlKullanici_User;
GO

SELECT
    princ.name AS KullaniciAdi,
    perm.permission_name AS Yetki,
    perm.state_desc AS YetkiDurumu, -- GRANT (izin verildi), DENY (yasaklandı)
    obj.name AS NesneAdi,
    sch.name AS SemaAdi
FROM
    sys.database_permissions AS perm
INNER JOIN
    sys.database_principals AS princ ON perm.grantee_principal_id = princ.principal_id
INNER JOIN
    sys.objects AS obj ON perm.major_id = obj.object_id
INNER JOIN
    sys.schemas AS sch ON obj.schema_id = sch.schema_id
WHERE
    princ.name = 'OrnekSqlKullanici_User' AND obj.name = 'Customers' AND sch.name = 'Website';
GO




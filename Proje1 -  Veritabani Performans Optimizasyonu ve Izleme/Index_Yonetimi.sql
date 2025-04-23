-- Eksik Indexleri Belirleme

USE AdventureWorksDW2022;
GO

SELECT
    db_name(mid.database_id) as DatabaseName,
    object_schema_name(mid.object_id, mid.database_id) + '.' + object_name(mid.object_id, mid.database_id) AS TableName,
    migs.avg_total_user_cost * migs.avg_user_impact * (migs.user_seeks + migs.user_scans) AS ImprovementMeasure,
    'CREATE NONCLUSTERED INDEX [IX_' + object_name(mid.object_id, mid.database_id) + '_'
        + REPLACE(REPLACE(REPLACE(ISNULL(mid.equality_columns,''),', ','_'),'[',''),']','')
        + CASE WHEN mid.equality_columns IS NOT NULL AND mid.inequality_columns IS NOT NULL THEN '_' ELSE '' END
        + REPLACE(REPLACE(REPLACE(ISNULL(mid.inequality_columns,''),', ','_'),'[',''),']','')
        + CASE WHEN mid.included_columns IS NOT NULL THEN '_Includes' ELSE '' END + ']' -- Added _Includes for clarity
    + ' ON ' + mid.statement -- schema.table name
    + ' (' + ISNULL (mid.equality_columns,'')
    + CASE WHEN mid.equality_columns IS NOT NULL AND mid.inequality_columns IS NOT NULL THEN ',' ELSE '' END
    + ISNULL (mid.inequality_columns, '') + ')'
    + ISNULL (' INCLUDE (' + mid.included_columns + ')', '') AS CreateIndexStatement,
    migs.user_seeks,
    migs.user_scans,
    migs.last_user_seek,
    migs.last_user_scan,
    mid.equality_columns,
    mid.inequality_columns,
    mid.included_columns
FROM sys.dm_db_missing_index_groups mig
INNER JOIN sys.dm_db_missing_index_group_stats migs ON migs.group_handle = mig.index_group_handle
INNER JOIN sys.dm_db_missing_index_details mid ON mig.index_handle = mid.index_handle
WHERE mid.database_id = DB_ID('AdventureWorksDW2022')
  AND mid.object_id = OBJECT_ID('dbo.FactInternetSales')
ORDER BY ImprovementMeasure DESC;
GO


-- Kullanýlmayan Ýndeksleri Belirleme
USE AdventureWorksDW2022;
GO

SELECT
    OBJECT_SCHEMA_NAME(i.object_id) AS SchemaName,
    OBJECT_NAME(i.object_id) AS TableName,
    i.name AS IndexName,
    i.type_desc AS IndexType,
    ius.user_seeks,
    ius.user_scans,
    ius.user_lookups,
    ius.user_updates,
    ius.last_user_seek,
    ius.last_user_scan,
    ius.last_user_lookup,
    (ISNULL(ius.user_seeks, 0) + ISNULL(ius.user_scans, 0) + ISNULL(ius.user_lookups, 0)) AS TotalReads -- Toplam okuma sayýsý
FROM sys.indexes i
INNER JOIN sys.objects o ON i.object_id = o.object_id
LEFT JOIN sys.dm_db_index_usage_stats ius ON i.object_id = ius.object_id AND i.index_id = ius.index_id AND ius.database_id = DB_ID('AdventureWorksDW2022')
WHERE o.is_ms_shipped = 0       -- Sistem nesnelerini hariç tut
  AND i.type_desc != 'HEAP'     -- Heap tablolarý hariç tut
  AND i.is_primary_key = 0      -- Primary key indekslerini hariç tut (genellikle gereklidir)
  AND i.is_unique_constraint = 0 -- Unique constraint indekslerini hariç tut (genellikle gereklidir)
  AND OBJECT_NAME(i.object_id) = 'FactInternetSales' -- Sadece FactInternetSales tablosu için
ORDER BY
    TotalReads ASC,              -- En az okunanlarý önce göster
    ius.user_updates DESC;       -- Okunma sayýsý ayný olanlardan en çok update alaný önce göster
GO

## Kullanýlmayan Ýndeks çýkmamasý sebebiyle Tüm indeksleri Belirleme ##
USE AdventureWorksDW2022;
GO

SELECT
    i.name AS IndexName,         -- Ýndeks Adý
    i.type_desc AS IndexType,    -- Ýndeks Tipi (Clustered, Nonclustered vb.)
    i.is_primary_key,            -- Primary Key mi? (1=Evet, 0=Hayýr)
    i.is_unique_constraint,      -- Unique Constraint mi? (1=Evet, 0=Hayýr)
    -- Ýndeksin anahtar sütunlarýný listele
    STUFF((
        SELECT ', ' + AC.name
        FROM sys.index_columns IC
        INNER JOIN sys.all_columns AC ON IC.object_id = AC.object_id AND IC.column_id = AC.column_id
        WHERE IC.object_id = i.object_id AND IC.index_id = i.index_id AND IC.is_included_column = 0
        ORDER BY IC.key_ordinal
        FOR XML PATH('')
    ), 1, 2, '') AS KeyColumns,  -- Anahtar Sütunlar
    -- Ýndekse dahil edilen (included) sütunlarý listele
    STUFF((
        SELECT ', ' + AC.name
        FROM sys.index_columns IC
        INNER JOIN sys.all_columns AC ON IC.object_id = AC.object_id AND IC.column_id = AC.column_id
        WHERE IC.object_id = i.object_id AND IC.index_id = i.index_id AND IC.is_included_column = 1
        ORDER BY IC.index_column_id
        FOR XML PATH('')
    ), 1, 2, '') AS IncludedColumns -- Dahil Edilen Sütunlar
FROM sys.indexes i
WHERE i.object_id = OBJECT_ID('dbo.FactInternetSales') -- Sadece FactInternetSales tablosu
ORDER BY
    i.type_desc,  -- Önce tipe göre sýrala
    i.name;       -- Sonra isme göre sýrala
GO

-- PRIMARY olmayan indeks olmadýðý için sorgumuz boþ dönmüþ.



-- FactInternetSales tablosundaki indekslerin parçalanma durumunu ve istatistiklerin en son ne zaman güncellendiðini kontrol etme
USE AdventureWorksDW2022;
GO

SELECT
    OBJECT_SCHEMA_NAME(ips.object_id) AS SchemaName,
    OBJECT_NAME(ips.object_id) AS TableName,
    i.name AS IndexName,
    ips.index_type_desc,
    ips.avg_fragmentation_in_percent,
    ips.page_count,
    st.name AS StatisticsName,
    STATS_DATE(st.object_id, st.stats_id) AS LastStatsUpdate
FROM sys.dm_db_index_physical_stats(DB_ID(), OBJECT_ID('dbo.FactInternetSales'), NULL, NULL, 'SAMPLED') AS ips -- 'SAMPLED' modu daha hýzlýdýr, 'DETAILED' daha kesindir.
INNER JOIN sys.indexes AS i ON ips.object_id = i.object_id AND ips.index_id = i.index_id
LEFT JOIN sys.stats st ON i.object_id = st.object_id AND i.name = st.name -- Ýndeks istatistiklerini eþleþtir
WHERE ips.page_count > 100
ORDER BY
    ips.avg_fragmentation_in_percent DESC;
GO


SELECT
    sch.name AS SchemaName,
    obj.name AS ObjectName,
    st.name AS StatisticsName,
    STATS_DATE(st.object_id, st.stats_id) AS LastStatsUpdate,
    st.auto_created,
    st.user_created,
    st.no_recompute
FROM sys.stats st
JOIN sys.objects obj ON st.object_id = obj.object_id
JOIN sys.schemas sch ON obj.schema_id = sch.schema_id
WHERE st.object_id = OBJECT_ID('dbo.FactInternetSales')
ORDER BY LastStatsUpdate DESC;
GO

-- Ýstatistik güncellemesi 
USE AdventureWorksDW2022;
GO

UPDATE STATISTICS dbo.FactInternetSales WITH FULLSCAN;
GO

-- Tüm Ýndekslerin Kullaným Ýstatistiklerini Görüntüleme
USE AdventureWorksDW2022;
GO

SELECT
    OBJECT_SCHEMA_NAME(i.object_id) AS SchemaName,
    OBJECT_NAME(i.object_id) AS TableName,
    i.name AS IndexName,
    i.type_desc AS IndexType,
    i.is_primary_key,
    ius.user_seeks,
    ius.user_scans,
    ius.user_lookups,
    ius.user_updates,
    (ISNULL(ius.user_seeks, 0) + ISNULL(ius.user_scans, 0) + ISNULL(ius.user_lookups, 0)) AS TotalReads, -- Toplam okuma
    ius.last_user_seek,
    ius.last_user_scan,
    ius.last_user_lookup,
    ius.last_user_update
FROM sys.indexes i
INNER JOIN sys.objects o ON i.object_id = o.object_id
LEFT JOIN sys.dm_db_index_usage_stats ius ON i.object_id = ius.object_id AND i.index_id = ius.index_id AND ius.database_id = DB_ID('AdventureWorksDW2022')
WHERE o.is_ms_shipped = 0       -- Sistem nesnelerini hariç tut
  AND i.type_desc != 'HEAP'     -- Heap tablolarý hariç tut
  AND OBJECT_NAME(i.object_id) = 'FactInternetSales' -- Sadece FactInternetSales tablosu için
ORDER BY
    IndexName;
GO
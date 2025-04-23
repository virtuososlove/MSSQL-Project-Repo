-- Dynamic Management Views (DMV) Kullanarak En Çok Kaynak Tüketen Sorgularý Bulma

USE AdventureWorksDW2022;
GO

SELECT TOP 10
    qs.total_worker_time / qs.execution_count AS avg_cpu_time,
    qs.total_worker_time AS total_cpu_time,
    qs.execution_count,
    qs.max_worker_time AS max_cpu_time,
    qs.total_elapsed_time / qs.execution_count AS avg_elapsed_time,
    qs.total_elapsed_time,
    qs.max_elapsed_time,
    SUBSTRING(st.text, (qs.statement_start_offset/2) + 1,
        ((CASE qs.statement_end_offset
          WHEN -1 THEN DATALENGTH(st.text)
         ELSE qs.statement_end_offset
         END - qs.statement_start_offset)/2) + 1) AS query_text,
    qp.query_plan
FROM
    sys.dm_exec_query_stats AS qs
CROSS APPLY
    sys.dm_exec_sql_text(qs.sql_handle) AS st
CROSS APPLY
    sys.dm_exec_query_plan(qs.plan_handle) AS qp
ORDER BY
    qs.total_worker_time DESC;
GO

-- Mevcut durumda  performans sorunu yaratan bir tüketim olduðu söylenemez. 

-- Bu sorguyla beraber Execution Plan yapýlýrsa ve Sonuç kýsmýndaki Messages bölümü incelenirse mevcut performans hakkýnda bilgi sahibi olunur 

USE AdventureWorksDW2022;
GO

SET STATISTICS IO ON;
SET STATISTICS TIME ON;
GO

SELECT
    dp.EnglishProductName          AS ProductName,
    dpc.EnglishProductCategoryName AS ProductCategory,
    dd.CalendarYear,
    SUM(fis.SalesAmount)           AS TotalSalesAmount
FROM
    dbo.FactInternetSales AS fis
INNER JOIN
    dbo.DimProduct AS dp ON fis.ProductKey = dp.ProductKey
INNER JOIN
    dbo.DimProductSubcategory AS dps ON dp.ProductSubcategoryKey = dps.ProductSubcategoryKey
INNER JOIN
    dbo.DimProductCategory AS dpc ON dps.ProductCategoryKey = dpc.ProductCategoryKey
INNER JOIN
    dbo.DimDate AS dd ON fis.OrderDateKey = dd.DateKey
WHERE
    dd.CalendarYear >= 2020
GROUP BY
    dp.EnglishProductName,
    dpc.EnglishProductCategoryName,
    dd.CalendarYear
ORDER BY
    ProductCategory,
    ProductName,
    CalendarYear;
GO

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
GO

-- Önerilen Nonclustered Indexini oluþturma
USE AdventureWorksDW2022;
GO

CREATE NONCLUSTERED INDEX [IX_FactInternetSales_OrderDateKey_Includes]
ON [dbo].[FactInternetSales] ([OrderDateKey])
INCLUDE ([ProductKey],[SalesAmount]);
GO

-- Performansta bir iyileþme olup olmadýðýnýn kontrolü
USE AdventureWorksDW2022;
GO

SET STATISTICS IO ON;
SET STATISTICS TIME ON;
GO

SELECT
    dp.EnglishProductName          AS ProductName,
    dpc.EnglishProductCategoryName AS ProductCategory,
    dd.CalendarYear,
    SUM(fis.SalesAmount)           AS TotalSalesAmount
FROM
    dbo.FactInternetSales AS fis
INNER JOIN
    dbo.DimProduct AS dp ON fis.ProductKey = dp.ProductKey
INNER JOIN
    dbo.DimProductSubcategory AS dps ON dp.ProductSubcategoryKey = dps.ProductSubcategoryKey
INNER JOIN
    dbo.DimProductCategory AS dpc ON dps.ProductCategoryKey = dpc.ProductCategoryKey
INNER JOIN
    dbo.DimDate AS dd ON fis.OrderDateKey = dd.DateKey
WHERE
    dd.CalendarYear >= 2020
GROUP BY
    dp.EnglishProductName,
    dpc.EnglishProductCategoryName,
    dd.CalendarYear
ORDER BY
    ProductCategory,
    ProductName,
    CalendarYear;
GO

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
GO
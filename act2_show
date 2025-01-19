-- Validate Row Counts
-- Check DIM_PRODUCT row count
SELECT COUNT(*) AS ProductCount FROM DIM_PRODUCT;

-- Check operational Product count
SELECT COUNT(*) AS ProductCount_Operational FROM CanyonRetailOperations.dbo.product;

-- Check DIM_CUSTOMER row count
SELECT COUNT(*) AS CustomerCount FROM DIM_CUSTOMER;

-- Check operational Customer count
SELECT COUNT(*) AS CustomerCount_Operational FROM CanyonRetailOperations.dbo.customer;

-- Check DIM_STORE row count
SELECT COUNT(*) AS StoreCount FROM DIM_STORE;

-- Check operational Store count
SELECT COUNT(*) AS StoreCount_Operational FROM CanyonRetailOperations.dbo.store;

-- Check DIM_DATE row count
SELECT COUNT(*) AS DateCount FROM DIM_DATE;

-- Check FACT_SALES row count
SELECT COUNT(*) AS FactSalesCount FROM FACT_SALES;

-- Check operational Transaction line count
SELECT COUNT(*) AS TransactionLineCount_Operational 
FROM CanyonRetailOperations.dbo.soldvia;

-- Validate Data Integrity
-- Validate DIM_PRODUCT data
SELECT dp.ProductName, dp.VendorName, dp.CategoryName, dp.StandardPrice
FROM DIM_PRODUCT dp
WHERE dp.OriginalProductID = 1; -- Replace with a known Product ID

-- Validate DIM_CUSTOMER data
SELECT dc.CustomerName, dc.ZipCode
FROM DIM_CUSTOMER dc
WHERE dc.OriginalCustomerID = 1; -- Replace with a known Customer ID

-- Validate DIM_STORE data
SELECT ds.StoreName, ds.ZipCode, ds.RegionName
FROM DIM_STORE ds
WHERE ds.OriginalStoreID = 'S1'; -- Replace with a known Store ID

-- Validate FACT_SALES data
SELECT fs.Quantity, fs.SalesAmount, dp.ProductName, dc.CustomerName, ds.StoreName, dd.FullDate
FROM FACT_SALES fs
JOIN DIM_PRODUCT dp ON fs.ProductKey = dp.ProductKey
JOIN DIM_CUSTOMER dc ON fs.CustomerKey = dc.CustomerKey
JOIN DIM_STORE ds ON fs.StoreKey = ds.StoreKey
JOIN DIM_DATE dd ON fs.DateKey = dd.DateKey
WHERE fs.Quantity > 0 -- Filter as needed for testing
LIMIT 10; -- Show sample rows

-- Validate Against Known Sample Data
SELECT fs.Quantity, fs.SalesAmount, dp.ProductName, dc.CustomerName, ds.StoreName, dd.FullDate
FROM FACT_SALES fs
JOIN DIM_PRODUCT dp ON fs.ProductKey = dp.ProductKey
JOIN DIM_CUSTOMER dc ON fs.CustomerKey = dc.CustomerKey
JOIN DIM_STORE ds ON fs.StoreKey = ds.StoreKey
JOIN DIM_DATE dd ON fs.DateKey = dd.DateKey
WHERE dp.ProductName = 'Zzz Bag'
  AND dc.CustomerName = 'Tina Adams'
  AND ds.StoreName = 'S1'
  AND dd.FullDate = '2024-01-01';

-- Run Aggregation Queries
-- Total sales amount by product
SELECT dp.ProductName, SUM(fs.SalesAmount) AS TotalSales
FROM FACT_SALES fs
JOIN DIM_PRODUCT dp ON fs.ProductKey = dp.ProductKey
GROUP BY dp.ProductName;

-- Total sales quantity by region
SELECT ds.RegionName, SUM(fs.Quantity) AS TotalQuantity
FROM FACT_SALES fs
JOIN DIM_STORE ds ON fs.StoreKey = ds.StoreKey
GROUP BY ds.RegionName;

-- Total sales by year
SELECT dd.[Year], SUM(fs.SalesAmount) AS TotalSales
FROM FACT_SALES fs
JOIN DIM_DATE dd ON fs.DateKey = dd.DateKey
GROUP BY dd.[Year];

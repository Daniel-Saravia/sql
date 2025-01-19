-- Query: Quantities of sold products on Wednesday in category Footwear provided by vendor Mountain King in Chicagoland for Q1 2024
SELECT fs.Quantity, dp.ProductName, dc.CustomerName, ds.StoreName, dd.FullDate
FROM FACT_SALES fs
JOIN DIM_PRODUCT dp ON fs.ProductKey = dp.ProductKey
JOIN DIM_STORE ds ON fs.StoreKey = ds.StoreKey
JOIN DIM_DATE dd ON fs.DateKey = dd.DateKey
WHERE dp.CategoryName = 'Footwear'
  AND dp.VendorName = 'Mountain King'
  AND ds.RegionName = 'Chicagoland'
  AND dd.Quarter = 'Q1'
  AND DATENAME(WEEKDAY, dd.FullDate) = 'Wednesday';

-- Create Data Warehouse Database
CREATE DATABASE CanyonRetailDW;
USE CanyonRetailDW;

-- Create Dimension Tables
CREATE TABLE DIM_PRODUCT (
    ProductKey      INT IDENTITY(1,1) PRIMARY KEY,
    ProductName     VARCHAR(50),
    VendorName      VARCHAR(50),
    CategoryName    VARCHAR(50),
    StandardPrice   DECIMAL(10,2),
    OriginalProductID INT
);

CREATE TABLE DIM_CUSTOMER (
    CustomerKey     INT IDENTITY(1,1) PRIMARY KEY,
    CustomerName    VARCHAR(50),
    ZipCode         CHAR(5),
    OriginalCustomerID INT
);

CREATE TABLE DIM_STORE (
    StoreKey        INT IDENTITY(1,1) PRIMARY KEY,
    StoreName       VARCHAR(50),
    ZipCode         CHAR(5),
    RegionName      VARCHAR(50),
    OriginalStoreID CHAR(2)
);

CREATE TABLE DIM_DATE (
    DateKey   INT IDENTITY(1,1) PRIMARY KEY,
    FullDate  DATE,
    [Day]     INT,
    [Month]   INT,
    [Year]    INT,
    Quarter   VARCHAR(2)
);

-- Create Fact Table
CREATE TABLE FACT_SALES (
    SalesKey       INT IDENTITY(1,1) PRIMARY KEY,
    ProductKey     INT NOT NULL,
    CustomerKey    INT NOT NULL,
    StoreKey       INT NOT NULL,
    DateKey        INT NOT NULL,
    Quantity       INT NOT NULL,
    SalesAmount    DECIMAL(10,2) NOT NULL,
    CONSTRAINT FK_FACT_PRODUCT  FOREIGN KEY (ProductKey)  REFERENCES DIM_PRODUCT(ProductKey),
    CONSTRAINT FK_FACT_CUSTOMER FOREIGN KEY (CustomerKey) REFERENCES DIM_CUSTOMER(CustomerKey),
    CONSTRAINT FK_FACT_STORE    FOREIGN KEY (StoreKey)    REFERENCES DIM_STORE(StoreKey),
    CONSTRAINT FK_FACT_DATE     FOREIGN KEY (DateKey)     REFERENCES DIM_DATE(DateKey)
);

-- Load Data into Dimension Tables
INSERT INTO DIM_PRODUCT (ProductName, VendorName, CategoryName, StandardPrice, OriginalProductID)
SELECT 
    p.product_name,
    v.vendor_name,
    c.category_name,
    p.price,
    p.product_id
FROM CanyonRetailOperations.dbo.product p
JOIN CanyonRetailOperations.dbo.vendor v
    ON p.vendor_id = v.vendor_id
JOIN CanyonRetailOperations.dbo.category c
    ON p.category_id = c.category_id;

INSERT INTO DIM_CUSTOMER (CustomerName, ZipCode, OriginalCustomerID)
SELECT 
    customer_name,
    zip_code,
    customer_id
FROM CanyonRetailOperations.dbo.customer;

INSERT INTO DIM_STORE (StoreName, ZipCode, RegionName, OriginalStoreID)
SELECT
    s.store_id AS StoreName,
    s.zip_code,
    r.region_name,
    s.store_id
FROM CanyonRetailOperations.dbo.store s
JOIN CanyonRetailOperations.dbo.region r
    ON s.region_id = r.region_id;

INSERT INTO DIM_DATE (FullDate, [Day], [Month], [Year], Quarter)
SELECT DISTINCT
    st.date_of_transaction AS FullDate,
    DAY(st.date_of_transaction) AS [Day],
    MONTH(st.date_of_transaction) AS [Month],
    YEAR(st.date_of_transaction) AS [Year],
    CASE 
        WHEN MONTH(st.date_of_transaction) IN (1,2,3)  THEN 'Q1'
        WHEN MONTH(st.date_of_transaction) IN (4,5,6)  THEN 'Q2'
        WHEN MONTH(st.date_of_transaction) IN (7,8,9)  THEN 'Q3'
        ELSE 'Q4'
    END AS Quarter
FROM CanyonRetailOperations.dbo.salestransaction st;

-- Load Data into Fact Table
INSERT INTO FACT_SALES (
    ProductKey,
    CustomerKey,
    StoreKey,
    DateKey,
    Quantity,
    SalesAmount
)
SELECT 
    dp.ProductKey,
    dc.CustomerKey,
    ds.StoreKey,
    dd.DateKey,
    sv.quantity,
    (sv.quantity * p.price) AS SalesAmount
FROM CanyonRetailOperations.dbo.soldvia sv
     JOIN CanyonRetailOperations.dbo.product p 
         ON sv.product_id = p.product_id
     JOIN CanyonRetailOperations.dbo.salestransaction st
         ON sv.transaction_id = st.transaction_id
     JOIN DIM_PRODUCT dp
         ON p.product_id = dp.OriginalProductID
     JOIN DIM_CUSTOMER dc
         ON st.customer_id = dc.OriginalCustomerID
     JOIN DIM_STORE ds
         ON st.store_id = ds.OriginalStoreID
     JOIN DIM_DATE dd
         ON st.date_of_transaction = dd.FullDate;


# ACIDTest SQL Stored Procedure Guide

## 1. Create and Populate the Tables

```sql
-- Create the ACIDTest database (if not already created)
CREATE DATABASE ACIDTest;
GO
USE ACIDTest;
GO

-- Create the Product Table
CREATE TABLE Product
(
  ProductID INT PRIMARY KEY,
  Name VARCHAR(40),
  Price MONEY,
  Quantity INT
);
GO

-- Populate the Product Table with test data
INSERT INTO Product VALUES(101, 'Laptop', 150.00, 100);
INSERT INTO Product VALUES(102, 'Desktop', 200.00, 150);
INSERT INTO Product VALUES(103, 'Mobile', 30.00, 200);
INSERT INTO Product VALUES(104, 'Tablet', 40.00, 250);
GO

-- Create the ProductSales Table
CREATE TABLE ProductSales
(
  ProductSalesID INT PRIMARY KEY,
  ProductID INT,
  QuantitySold INT
);
GO

-- Populate the ProductSales Table with test data
INSERT INTO ProductSales VALUES(1, 101, 10);
INSERT INTO ProductSales VALUES(2, 102, 15);
INSERT INTO ProductSales VALUES(3, 103, 30);
INSERT INTO ProductSales VALUES(4, 104, 35);
GO
```

---

## 2. Develop the Stored Procedure

```sql
CREATE PROCEDURE spSellProduct
    @ProductID INT,
    @QuantityToSell INT
AS
BEGIN
    -- Check the stock available for the product we want to sell
    DECLARE @StockAvailable INT;

    SELECT @StockAvailable = Quantity
    FROM Product
    WHERE ProductID = @ProductID;

    -- Throw an error if the stock is less than the quantity we want to sell
    IF (@StockAvailable < @QuantityToSell)
    BEGIN
        RAISERROR('Enough Stock is not available', 16, 1);
    END
    ELSE
    BEGIN
        BEGIN TRY
            -- Start the transaction
            BEGIN TRANSACTION;

            -- Reduce the quantity available in the Product table
            UPDATE Product 
            SET Quantity = (Quantity - @QuantityToSell)
            WHERE ProductID = @ProductID;

            -- Calculate MAX(ProductSalesID) from ProductSales
            DECLARE @MaxProductSalesId INT;
            SELECT @MaxProductSalesId = CASE
                                            WHEN MAX(ProductSalesID) IS NULL THEN 0
                                            ELSE MAX(ProductSalesID)
                                        END
            FROM ProductSales;

            -- Increment @MaxProductSalesId by 1 to avoid primary key violation
            SET @MaxProductSalesId = @MaxProductSalesId + 1;

            -- Insert the sold quantity into the ProductSales table
            INSERT INTO ProductSales(ProductSalesID, ProductID, QuantitySold)
            VALUES(@MaxProductSalesId, @ProductID, @QuantityToSell);

            -- Commit the transaction
            COMMIT TRANSACTION;
        END TRY
        BEGIN CATCH
            -- Rollback the transaction in case of any error
            ROLLBACK TRANSACTION;
            -- Optionally, re-raise the error or log it
            DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
            RAISERROR(@ErrorMessage, 16, 1);
        END CATCH
    END
END;
GO
```

---

## 3. Verify the Stored Procedure

- Expand the **ACIDTest** database in SSMS Object Explorer.
- Go to **Programmability > Stored Procedures**.
- Confirm `spSellProduct` exists.

---

## 4. Test the Stored Procedure

### 4.1 Sufficient Stock

```sql
EXEC spSellProduct @ProductID = 101, @QuantityToSell = 5;
```

**Expected:** Product quantity decreases by 5 and new ProductSales entry is added.

### 4.2 Insufficient Stock

```sql
EXEC spSellProduct @ProductID = 103, @QuantityToSell = 250;
```

**Expected:** Error: `'Enough Stock is not available'`, no changes to DB.

---

## 5. Capture Evidence

- Take screenshots showing:
  - A successful sale.
  - An error due to low stock.
- Paste them into the participation discussion post.

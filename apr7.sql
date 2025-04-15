-- Use the correct database
USE AdventureWorks2017;
GO

-- Step 1: Drop old trigger and audit table if they exist
IF OBJECT_ID('Sales.trg_AuditSalesQuota', 'TR') IS NOT NULL
    DROP TRIGGER Sales.trg_AuditSalesQuota;
GO

IF OBJECT_ID('Sales.SalesQuotaAudit', 'U') IS NOT NULL
    DROP TABLE Sales.SalesQuotaAudit;
GO

-- Step 2: Create the audit table
CREATE TABLE Sales.SalesQuotaAudit
(
    QuotaAuditID INT IDENTITY(1,1) PRIMARY KEY,
    BusinessEntityID INT NOT NULL,
    OldQuota MONEY,
    NewQuota MONEY,
    ChangeDate DATETIME DEFAULT GETDATE()
);
GO

-- Step 3: Create the trigger to log quota changes
CREATE TRIGGER Sales.trg_AuditSalesQuota
ON Sales.SalesPerson
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Sales.SalesQuotaAudit (BusinessEntityID, OldQuota, NewQuota)
    SELECT 
        d.BusinessEntityID,
        d.SalesQuota AS OldQuota,
        i.SalesQuota AS NewQuota
    FROM 
        deleted d
    INNER JOIN 
        inserted i ON d.BusinessEntityID = i.BusinessEntityID
    WHERE 
        ISNULL(d.SalesQuota, 0) <> ISNULL(i.SalesQuota, 0);
END;
GO

-- Step 4: Find a salesperson with a quota to use
SELECT TOP 1 BusinessEntityID, SalesQuota 
INTO #TempQuota
FROM Sales.SalesPerson
WHERE SalesQuota IS NOT NULL;
GO

-- Step 5: Declare and set the original quota
DECLARE @EntityID INT, @OriginalQuota MONEY;

SELECT 
    @EntityID = BusinessEntityID,
    @OriginalQuota = SalesQuota
FROM #TempQuota;

-- Step 6: Update quota to trigger audit log
UPDATE Sales.SalesPerson
SET SalesQuota = @OriginalQuota + 1000
WHERE BusinessEntityID = @EntityID;
GO

-- Step 7: Revert quota to original
UPDATE Sales.SalesPerson
SET SalesQuota = @OriginalQuota
WHERE BusinessEntityID = @EntityID;
GO

-- Step 8: Display audit log (should have 2 entries)
SELECT * FROM Sales.SalesQuotaAudit
WHERE BusinessEntityID = @EntityID;
GO

-- Cleanup temp table
DROP TABLE #TempQuota;
GO

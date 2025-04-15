-- Use the AdventureWorks2017 database
USE AdventureWorks2017;
GO

-- Step 1: Create the audit log table
IF OBJECT_ID('Sales.SalesQuotaAudit', 'U') IS NOT NULL DROP TABLE Sales.SalesQuotaAudit;
GO

CREATE TABLE Sales.SalesQuotaAudit
(
    QuotaAuditID INT IDENTITY(1,1) PRIMARY KEY,
    BusinessEntityID INT NOT NULL,
    OldQuota MONEY,
    NewQuota MONEY,
    ChangeDate DATETIME DEFAULT GETDATE()
);
GO

-- Step 2: Create the trigger to log changes to SalesQuota
IF OBJECT_ID('Sales.trg_AuditSalesQuota', 'TR') IS NOT NULL DROP TRIGGER Sales.trg_AuditSalesQuota;
GO

CREATE TRIGGER Sales.trg_AuditSalesQuota
ON Sales.SalesPerson
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Insert a record into the audit table only if SalesQuota has changed
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

-- Step 3: Make a change to trigger the audit (get one valid BusinessEntityID first)
SELECT BusinessEntityID, SalesQuota FROM Sales.SalesPerson WHERE SalesQuota IS NOT NULL;
-- Suppose we pick BusinessEntityID = 274 (adjust based on your result)
-- Save the original value
DECLARE @OriginalQuota MONEY;
SELECT @OriginalQuota = SalesQuota FROM Sales.SalesPerson WHERE BusinessEntityID = 274;

-- Change the quota to trigger the audit
UPDATE Sales.SalesPerson
SET SalesQuota = @OriginalQuota + 1000
WHERE BusinessEntityID = 274;
GO

-- Step 4: Change it back to the original amount
UPDATE Sales.SalesPerson
SET SalesQuota = @OriginalQuota
WHERE BusinessEntityID = 274;
GO

-- Step 5: Verify the audit log has two entries
SELECT * FROM Sales.SalesQuotaAudit WHERE BusinessEntityID = 274;
GO

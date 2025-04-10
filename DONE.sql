USE AdventureWorks2017;
GO

-- Drop the audit log table if it exists (for a clean slate)
IF OBJECT_ID('dbo.PersonTypeAuditLog', 'U') IS NOT NULL
    DROP TABLE dbo.PersonTypeAuditLog;
GO

-- Drop the trigger if it already exists
IF OBJECT_ID('trg_PersonTypeAudit', 'TR') IS NOT NULL
    DROP TRIGGER trg_PersonTypeAudit;
GO

-- Create Audit Log Table to capture changes of PersonType
CREATE TABLE dbo.PersonTypeAuditLog
(
    AuditID INT IDENTITY(1,1) PRIMARY KEY,
    BusinessEntityID INT,
    OldPersonType nchar(2),
    NewPersonType nchar(2),
    ChangeDate DATETIME DEFAULT GETDATE()
);
GO

-- Create Trigger on Person.Person that fires after an update to log PersonType changes
CREATE TRIGGER trg_PersonTypeAudit
ON Person.Person
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO dbo.PersonTypeAuditLog (BusinessEntityID, OldPersonType, NewPersonType, ChangeDate)
    SELECT d.BusinessEntityID, d.PersonType, i.PersonType, GETDATE()
    FROM DELETED d
    INNER JOIN INSERTED i ON d.BusinessEntityID = i.BusinessEntityID
    WHERE d.PersonType <> i.PersonType;
END;
GO

-- Insert a new record for Daniel Saravia
-- Note: Adjust Title, MiddleName, and Suffix as needed. Here we assume:
-- Title = 'Mr.' and no MiddleName or Suffix are provided.
INSERT INTO Person.Person 
    (BusinessEntityID, PersonType, NameStyle, Title, FirstName, MiddleName, LastName, Suffix, EmailPromotion, AdditionalContactInfo, Demographics, rowguid, ModifiedDate)
VALUES 
    (292,                     -- BusinessEntityID
     'EM',                    -- PersonType
     0,                       -- NameStyle (0 = false)
     'Mr.',                   -- Title
     'Daniel',                -- FirstName
     NULL,                    -- MiddleName (set to NULL if no middle initial)
     'Saravia',               -- LastName
     NULL,                    -- Suffix (use NULL if none)
     0,                       -- EmailPromotion
     NULL,                    -- AdditionalContactInfo
     NULL,                    -- Demographics
     'D0A499A2-C226-43E9-AB06-F61543A71135',  -- rowguid
     DATEADD(day, -1, GETDATE())); -- ModifiedDate set to yesterday’s date
GO

-- Select all distinct PersonTypes from the Person.Person table
SELECT DISTINCT PersonType
FROM Person.Person;
GO

-- Update Daniel Saravia's PersonType from 'EM' to 'GM' to test the trigger.
UPDATE Person.Person
SET PersonType = 'GM'
WHERE BusinessEntityID = 292;
GO

-- Select all records from the audit log table to see the captured change
SELECT *
FROM dbo.PersonTypeAuditLog;
GO

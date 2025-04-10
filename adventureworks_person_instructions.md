
# SQL Instructions for AdventureWorks2017 - Person.Person Table

## 1. Insert a New Person

```sql
USE AdventureWorks2017;
GO

-- Insert a new person record into Person.Person
INSERT INTO Person.Person
    (BusinessEntityID, PersonType, NameStyle, Title, FirstName, MiddleName, LastName, Suffix, EmailPromotion, AdditionalContactInfo, Demographics, rowguid, ModifiedDate)
VALUES 
    (
      292,                      -- BusinessEntityID
      'EM',                     -- PersonType 
      0,                        -- NameStyle (0 = false)
      'Mr.',                    -- Title (replace with your title: 'Mr.', 'Ms.', etc.)
      'John',                   -- FirstName (replace with your first name)
      'A',                      -- MiddleName (your middle initial)
      'Doe',                    -- LastName (replace with your last name)
      NULL,                     -- Suffix (replace if you have one, otherwise leave as NULL)
      0,                        -- EmailPromotion
      NULL,                     -- AdditionalContactInfo
      NULL,                     -- Demographics
      'D0A499A2-C226-43E9-AB06-F61543A71135',  -- rowguid
      DATEADD(day, -1, GETDATE())  -- ModifiedDate (yesterday)
    );
GO
```

## 2. List All Person Types

```sql
USE AdventureWorks2017;
GO

SELECT DISTINCT PersonType
FROM Person.Person;
GO
```

## 3. Create an Audit Log Trigger

### a. Create Audit Log Table

```sql
USE AdventureWorks2017;
GO

CREATE TABLE dbo.PersonTypeAuditLog
(
    AuditID INT IDENTITY(1,1) PRIMARY KEY,
    BusinessEntityID INT,
    OldPersonType nchar(2),
    NewPersonType nchar(2),
    ChangeDate DATETIME DEFAULT GETDATE()
);
GO
```

### b. Create Trigger

```sql
USE AdventureWorks2017;
GO

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
```

## 4. Test the Trigger

### a. Change PersonType

```sql
USE AdventureWorks2017;
GO

UPDATE Person.Person
SET PersonType = 'GM'  -- Change from 'EM' to another type
WHERE BusinessEntityID = 292;
GO
```

### b. View the Audit Log

```sql
USE AdventureWorks2017;
GO

SELECT *
FROM dbo.PersonTypeAuditLog;
GO
```

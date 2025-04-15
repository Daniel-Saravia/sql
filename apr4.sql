-- Use the correct database
USE Sharding;
GO

-- Step 1: Drop tables if they already exist
IF OBJECT_ID('OriginalTable', 'U') IS NOT NULL DROP TABLE OriginalTable;
IF OBJECT_ID('HorizontalShard1', 'U') IS NOT NULL DROP TABLE HorizontalShard1;
IF OBJECT_ID('HorizontalShard2', 'U') IS NOT NULL DROP TABLE HorizontalShard2;
GO

-- Step 2: Create OriginalTable
CREATE TABLE OriginalTable
(
    CustomerId int NOT NULL PRIMARY KEY,
    FirstName nvarchar(50) NULL,
    LastName nvarchar(50) NULL,
    City nvarchar(50) NULL
);
GO

-- Step 3: Insert sample data
INSERT INTO OriginalTable VALUES (1, 'Alice', 'Anderson', 'Austin');
INSERT INTO OriginalTable VALUES (2, 'Bob', 'Best', 'Boston');
INSERT INTO OriginalTable VALUES (3, 'Carrie', 'Conway', 'Chicago');
INSERT INTO OriginalTable VALUES (4, 'David', 'Doe', 'Denver');
GO

-- Step 4: Create HorizontalShard1
CREATE TABLE HorizontalShard1
(
    CustomerId int NOT NULL PRIMARY KEY,
    FirstName nvarchar(50) NULL,
    LastName nvarchar(50) NULL,
    City nvarchar(50) NULL
);
GO

-- Step 5: Create HorizontalShard2
CREATE TABLE HorizontalShard2
(
    CustomerId int NOT NULL PRIMARY KEY,
    FirstName nvarchar(50) NULL,
    LastName nvarchar(50) NULL,
    City nvarchar(50) NULL
);
GO

-- Step 6: Insert into HorizontalShard1 (LastName starts with A or B)
INSERT INTO HorizontalShard1(CustomerID, FirstName, LastName, City)
SELECT CustomerID, FirstName, LastName, City
FROM OriginalTable
WHERE SUBSTRING(LastName, 1, 1) = 'A' OR SUBSTRING(LastName, 1, 1) = 'B';
GO

-- Step 7: Insert into HorizontalShard2 (LastName starts with C or D)
INSERT INTO HorizontalShard2(CustomerID, FirstName, LastName, City)
SELECT CustomerID, FirstName, LastName, City
FROM OriginalTable
WHERE SUBSTRING(LastName, 1, 1) = 'C' OR SUBSTRING(LastName, 1, 1) = 'D';
GO

-- Step 8: View results from both shards
SELECT * FROM HorizontalShard1;
SELECT * FROM HorizontalShard2;

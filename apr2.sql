-- Use the target database
USE Sharding
GO

-- Step 1: Create OriginalTable
CREATE TABLE OriginalTable
(
    CustomerId int NOT NULL PRIMARY KEY,
    FirstName nvarchar(50) NULL,
    LastName nvarchar(50) NULL,
    City nvarchar(50) NULL
)
GO

-- Step 2: Insert sample data
INSERT INTO OriginalTable VALUES (1, 'Alice', 'Anderson', 'Austin');
INSERT INTO OriginalTable VALUES (2, 'Bob', 'Best', 'Boston');
INSERT INTO OriginalTable VALUES (3, 'Carrie', 'Conway', 'Chicago');
INSERT INTO OriginalTable VALUES (4, 'David', 'Doe', 'Denver');
GO

-- Step 3: Create HorizontalShard1 (Same schema)
CREATE TABLE HorizontalShard1
(
    CustomerId int NOT NULL PRIMARY KEY,
    FirstName nvarchar(50) NULL,
    LastName nvarchar(50) NULL,
    City nvarchar(50) NULL
)
GO

-- Step 4: Create HorizontalShard2 (Same schema)
CREATE TABLE HorizontalShard2
(
    CustomerId int NOT NULL PRIMARY KEY,
    FirstName nvarchar(50) NULL,
    LastName nvarchar(50) NULL,
    City nvarchar(50) NULL
)
GO

-- Step 5: Distribute rows into Horizontal Shards
-- Example logic: Shard1 for CustomerId <= 2, Shard2 for > 2

INSERT INTO HorizontalShard1
SELECT * FROM OriginalTable WHERE CustomerId <= 2;
GO

INSERT INTO HorizontalShard2
SELECT * FROM OriginalTable WHERE CustomerId > 2;
GO

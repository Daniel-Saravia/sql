-- Use the Sharding database
USE [Sharding]
GO

-- Create the OriginalTable
CREATE TABLE OriginalTable
(
    CustomerId int NOT NULL PRIMARY KEY,
    FirstName nvarchar(50) NULL,
    LastName nvarchar(50) NULL,
    City nvarchar(50) NULL
)
GO

-- Insert sample data into OriginalTable
INSERT INTO OriginalTable VALUES (1, 'Alice', 'Anderson', 'Austin');
INSERT INTO OriginalTable VALUES (2, 'Bob', 'Best', 'Boston');
INSERT INTO OriginalTable VALUES (3, 'Carrie', 'Conway', 'Chicago');
INSERT INTO OriginalTable VALUES (4, 'David', 'Doe', 'Denver');
GO

-- Create VerticalShard1 (CustomerId, FirstName, LastName)
CREATE TABLE VerticalShard1
(
    CustomerId int NOT NULL PRIMARY KEY,
    FirstName nvarchar(50) NULL,
    LastName nvarchar(50) NULL
)
GO

-- Create VerticalShard2 (CustomerId, City)
CREATE TABLE VerticalShard2
(
    CustomerId int NOT NULL PRIMARY KEY,
    City nvarchar(50) NULL
)
GO

-- Insert data into VerticalShard1
INSERT INTO VerticalShard1 (CustomerId, FirstName, LastName)
SELECT CustomerId, FirstName, LastName FROM OriginalTable;
GO

-- Insert data into VerticalShard2
INSERT INTO VerticalShard2 (CustomerId, City)
SELECT CustomerId, City FROM OriginalTable;
GO

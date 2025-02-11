# SQL XML Processing Screenshots and Instructions

## 1. Screenshot of the SELECT Statement and Result Window

### One-Line Description:
Screenshot showing the SQL query (with system date/time visible) and the XML-formatted result output in SSMS.

### Steps to Produce This Screenshot:

#### Start Your Virtual Machine:
- Log in to the VM, click Start, type SSMS, and launch SQL Server Management Studio.

#### Connect to Your SQL Server Instance:
- Connect to the instance and expand Databases in Object Explorer.

#### Open a New Query Window on AdventureWorks2017:
- Right-click on the AdventureWorks2017 database and select **New Query**.

#### Enter and Execute the Following SQL Query:
```sql
SELECT TOP 5 BusinessEntityID, FirstName, LastName
FROM Person.Person
WHERE FirstName = 'John'
FOR XML PATH('Person'), ROOT('Persons');
```

#### Capture the Screenshot:
- Ensure that both the query text and the resulting XML output are visible in the SSMS window (with the current system date/time visible somewhere on the screen) and take a screenshot.

---

## 2. Screenshot of the Saved XML File (xmlTest.xml)

### One-Line Description:
Screenshot showing the XML file (`xmlTest.xml`) opened in SSMS with its XML view, ensuring the file name and system date/time are visible.

### Steps to Produce This Screenshot:

#### Open the XML View:
- In the SSMS results pane from the previous query, click on the XML link to open the XML result in a new tab.

#### Save the XML File:
- Right-click on the query tab (or use **File > Save**) and save the file as `xmlTest.xml`.
- *(Note: Verify that the file is saved to a location accessible for later use in your SQL transaction.)*

#### Capture the Screenshot:
- Open the saved file (if not already open) and take a screenshot showing the file name (`xmlTest.xml`) and the XML content with system date/time visible.

---

## 3. Screenshot of the SQL Transaction Code (Importing XML) and Its Results

### One-Line Description:
Screenshot displaying the complete SQL transaction code (including the use of `OPENROWSET`, `sp_xml_preparedocument`, `OPENXML`, and `sp_xml_removedocument`) along with the resulting output showing only the first and last names from the XML document in SSMS.

### Steps to Produce This Screenshot:

#### Switch to the `OPENXMLTesting` Database:
- Ensure that you are using the `OPENXMLTesting` database. *(If not created, you may create it beforehand.)*

#### Create a Table for the Imported Data:
- Create a table that holds the first and last names. For example, you might name the table `ImportedPersons`.

#### Write and Execute the SQL Transaction Code:

```sql
-- Use the target database
USE OPENXMLTesting;
GO

-- Create the table to store the imported data (if it does not already exist)
IF OBJECT_ID('dbo.ImportedPersons', 'U') IS NOT NULL
    DROP TABLE dbo.ImportedPersons;
GO

CREATE TABLE dbo.ImportedPersons
(
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50)
);
GO

-- Declare variables for the XML data and document handle
DECLARE @XMLData XML;
DECLARE @DocHandle INT;

-- Read the XML file into the @XMLData variable.
-- Make sure the file path below is accessible by SQL Server.
SET @XMLData = (
    SELECT CONVERT(XML, BulkColumn)
    FROM OPENROWSET(BULK 'C:\Path\To\xmlTest.xml', SINGLE_BLOB) AS x
);

-- Prepare the XML document for parsing
EXEC sp_xml_preparedocument @DocHandle OUTPUT, @XMLData;

-- Insert data from the XML document into the table
INSERT INTO dbo.ImportedPersons (FirstName, LastName)
SELECT FirstName, LastName
FROM OPENXML(@DocHandle, '/Persons/Person', 2)
WITH (
    FirstName NVARCHAR(50) 'FirstName',
    LastName  NVARCHAR(50) 'LastName'
);

-- Remove the XML document from memory
EXEC sp_xml_removedocument @DocHandle;

-- Display only the first and last names from the imported data
SELECT FirstName, LastName
FROM dbo.ImportedPersons;
GO
```

### Notes:
- Replace `C:\Path\To\xmlTest.xml` with the actual path where your XML file is stored.
- Ensure that the SQL Server instance has permissions to read from that directory.
- The code uses `OPENROWSET` with the `BULK` option to load the XML file and then uses `sp_xml_preparedocument` and `OPENXML` to parse and insert the data into your table.

#### Capture the Screenshot:
- After executing the transaction code, capture a screenshot that shows both the full code in your query window and the results (i.e., the list of first and last names for all 'John' records) with the system date/time visible.

---

## Final Submission Checklist

### Section 1:
✅ Screenshot of the **SELECT statement** and XML result window with one-line description.

### Section 2:
✅ Screenshot of the **saved XML file (xmlTest.xml)** with one-line description.

### Section 3:
✅ Screenshot of the **complete SQL transaction code** along with the result output, including only the first and last names, with one-line description.

📌 **Compile all three screenshots and their respective descriptions into a single document (e.g., a Word document) as required by your digital classroom submission instructions.**

By following these steps and using the provided sample code, you will have demonstrated your understanding of how to generate XML from SQL Server data and how to import that XML into SQL Server using `OPENROWSET` and `OPENXML`. Adjust the file paths and any environment-specific details as necessary for your configuration.

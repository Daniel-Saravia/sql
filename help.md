# ETL Process Using SQL Server and SSDT

## 1. Generate Your Data with generatedata.com

1. **Visit generatedata.com:**  
   - Open your browser and go to [generatedata.com](https://generatedata.com).

2. **Configure Your Data:**  
   - **Record Count:** Set the number of records to 50.  
   - **Fields to Include:**  
     - **Name**  
     - **Street Address**  
     - **Postal/Zip:** When configuring this field, choose the US format (i.e. US Zip Code).

3. **Choose Output Format:**  
   - Select **CSV** as the output format.

4. **Generate & Download:**  
   - Click the “Generate” button and download your CSV file.

---

## 2. Load the CSV Data into SQL Server

### A. Create a Staging Table

Open SQL Server Management Studio (SSMS) and run a script to create a table that matches your CSV file’s structure:

```sql
CREATE TABLE dbo.GeneratedData (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(100),
    StreetAddress VARCHAR(200),
    PostalZip VARCHAR(10)
);
```

### B. Import the CSV Data

Options to import:
- **BULK INSERT:** Use T‑SQL’s BULK INSERT command.
- **SQL Server Import Wizard:** Right-click your database → Tasks → Import Data, and follow the wizard to load the CSV.

---

## 3. Set Up a Zip Code Lookup Table

### A. Create the Lookup Table

```sql
CREATE TABLE dbo.ZipLookup (
    ZipCode VARCHAR(10) PRIMARY KEY,
    City VARCHAR(100),
    State VARCHAR(50)
);
```

### B. Populate the Lookup Table

Option 1: Download a US zip code dataset and import it into `dbo.ZipLookup`.  
Option 2: Manually insert a few rows for testing:

```sql
INSERT INTO dbo.ZipLookup (ZipCode, City, State) VALUES
('90210', 'Beverly Hills', 'CA'),
('10001', 'New York', 'NY'),
('60601', 'Chicago', 'IL');
```

---

## 4. Perform the ETL Process

### A. Using SQL Server Management Studio (T‑SQL)

```sql
SELECT 
    g.Name,
    g.StreetAddress,
    z.City,
    z.State,
    g.PostalZip,
    g.StreetAddress + ', ' + z.City + ', ' + z.State + ' ' + g.PostalZip AS FullAddress
FROM dbo.GeneratedData g
JOIN dbo.ZipLookup z
    ON g.PostalZip = z.ZipCode;
```

### B. Using Visual Studio SSDT (SSIS Package)

1. **Create a New SSIS Project:**  
   - Open Visual Studio with SQL Server Data Tools (SSDT).
   - Create a new **Integration Services Project**.

2. **Design the Data Flow:**  
   - **Flat File Source:** Configure to read the CSV file.
   - **Lookup Transformation:** Use `dbo.ZipLookup` to find the City and State.
   - **Derived Column Transformation:** Concatenate the fields:
     
     ```
     StreetAddress + ", " + City + ", " + State + " " + PostalZip
     ```
   - **OLE DB Destination:** Store the final data in SQL Server.

3. **Deploy and Execute:**  
   - Build and run the SSIS package.
   - Validate data in the destination table.

---

## 5. Verification

- **In SSMS:** Run a SELECT query to verify the `FullAddress` column.
- **In SSIS:** Use Data Viewers to inspect the transformed data.

This guide walks through the full ETL process, from generating test data to integrating it with a zip code lookup and transforming it using both T‑SQL and SSDT.

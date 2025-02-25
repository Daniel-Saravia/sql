# ETL Process Using SSIS and SSMS

## 1. Generate the Source Data

- **Visit generatedata.com:**  
  Use the website to create a CSV file with 50 records.  
  - **Select Fields:** Choose at least "Name", "Street Address", and "Postal/Zip".  
  - **US Zip Codes:** Ensure you choose US zip codes for the Postal/Zip field.  
  - **CSV Format:** Export the data as a CSV file.

---

## 2. Prepare a Zip Code Lookup Table

Since your CSV only includes the Postal/Zip, you need a reference table that maps zip codes to their corresponding City and State. You can:

- **Download a Public Dataset:** There are many free sources available online (for example, from public government datasets).
- **Create the Table Manually:** For testing purposes, you might create a small lookup table in SQL Server. For example:

```sql
CREATE TABLE ZipCodeLookup (
    PostalZip VARCHAR(10) PRIMARY KEY,
    City VARCHAR(100),
    State VARCHAR(50)
);

-- Insert sample data
INSERT INTO ZipCodeLookup (PostalZip, City, State)
VALUES ('90210', 'Beverly Hills', 'CA'),
       ('10001', 'New York', 'NY');
```

*Note:* Make sure your lookup table covers all zip codes present in your CSV file.

---

## 3. Set Up Your SSIS Project in Visual Studio SSDT

1. **Create a New SSIS Project:**  
   In Visual Studio SSDT, create a new Integration Services Project.
2. **Add a Data Flow Task:**  
   Open the SSIS package and drag a Data Flow Task onto the Control Flow canvas.

---

## 4. Configure the Data Flow

### a. Flat File Source (Extract)

- **Add a Flat File Connection Manager:**  
  Point this to your generated CSV file.
- **Configure the Flat File Source Component:**  
  In the Data Flow, add a Flat File Source and select your connection manager. Ensure that the columns (Name, Street Address, Postal/Zip) are correctly recognized.

### b. Lookup Transformation (Enhance)

- **Add a Lookup Component:**  
  Drag a Lookup transformation into the Data Flow.
- **Configure the Lookup:**  
  - **Connection:** Set it to point to the SQL Server database containing your `ZipCodeLookup` table.
  - **Join:** Map the CSV’s Postal/Zip field to the PostalZip field in the lookup table.
  - **Output Columns:** Choose to return the City and State columns.
  
This step “enriches” your data by adding City and State for each record based on the zip code.

### c. Derived Column Transformation (Transform)

- **Add a Derived Column Component:**  
  After the Lookup, add a Derived Column transformation.
- **Concatenate the Address Fields:**  
  Create a new column (e.g., `FullAddress`) using an expression that combines Street Address, City, State, and Postal/Zip.  
  
  ```
  [Street Address] + ", " + [City] + ", " + [State] + " " + [Postal/Zip]
  ```
  
  Adjust the field names as they appear in your data flow.

### d. Destination (Load)

- **SQL Server Destination:**  
  Finally, add an OLE DB Destination component that points to the target SQL Server table.
- **Create the Target Table:**  
  
  ```sql
  CREATE TABLE ConsolidatedAddresses (
      Name NVARCHAR(100),
      StreetAddress NVARCHAR(200),
      City NVARCHAR(100),
      State NVARCHAR(50),
      PostalZip VARCHAR(10),
      FullAddress NVARCHAR(400)
  );
  ```

- **Map Columns:**  
  Ensure that the source columns (including your new `FullAddress` column) map correctly to the destination columns.

---

## 5. Deploy and Test

- **Run the SSIS Package:**  
  Execute the package in Visual Studio to extract data from your CSV, perform the lookup and concatenation, and load it into SQL Server.
- **Verify in SSMS:**  
  Open SQL Server Management Studio and query the target table:

  ```sql
  SELECT TOP 10 * FROM ConsolidatedAddresses;
  ```

This confirms that the Street Address, City, State, and Postal/Zip have been concatenated into the FullAddress field.

---

## Summary

- **Generate Data:** Use generatedata.com for a CSV file with 50 records (Name, Street Address, Postal/Zip).
- **Lookup Table:** Prepare a reference table mapping Postal/Zip to City and State.
- **SSIS Package:**  
  1. **Extract:** Read CSV with a Flat File Source.  
  2. **Enrich:** Use a Lookup transformation to add City and State.  
  3. **Transform:** Create a concatenated FullAddress column with a Derived Column transformation.  
  4. **Load:** Insert the data into a SQL Server table.
- **Validation:** Use SSMS to query the loaded data and verify the transformation.

This workflow uses two inputs (your CSV file and the zip code lookup table) to generate one output (the fully concatenated address). Adjust field names and connection details as needed for your environment.

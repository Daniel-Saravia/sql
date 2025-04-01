1. Import Tables with M Code
You can paste the following M code into the Advanced Editor of Power Query for each table. (Repeat for each table, or use separate queries.) Replace "YourServerName" with your actual server name.

For FactResellerSales:

m
Copy
Edit
let
    Source = Sql.Database("YourServerName", "AdventureWorksDW2017"),
    FactResellerSales = Source{[Schema="dbo",Item="FactResellerSales"]}[Data]
in
    FactResellerSales
For DimProduct:

m
Copy
Edit
let
    Source = Sql.Database("YourServerName", "AdventureWorksDW2017"),
    DimProduct = Source{[Schema="dbo",Item="DimProduct"]}[Data]
in
    DimProduct
For DimReseller:

m
Copy
Edit
let
    Source = Sql.Database("YourServerName", "AdventureWorksDW2017"),
    DimReseller = Source{[Schema="dbo",Item="DimReseller"]}[Data]
in
    DimReseller
Tip: Once loaded, go to the Model view to verify that the proper relationships (typically on reseller or product keys) are created between these tables.

2. Create a Total Sales Measure for Each Reseller
Measures are created using DAX (not M). In the FactResellerSales table, create a new measure with this DAX code:

DAX
Copy
Edit
Total Sales = SUM(FactResellerSales[SalesAmount])
This measure sums up the SalesAmount for each reseller once you relate FactResellerSales to DimReseller (usually via a common key such as ResellerKey or ResellerID).

3. Build a Matrix Visual in Your Report
In the Report view, insert a Matrix visual.

Rows: Drag the reseller name field from the DimReseller table.

Values: Drag the Total Sales measure.

This matrix will now display each reseller alongside their total sales amount.

4. Create a Measure to Show Sales for 2011 Only
Assuming your FactResellerSales table contains a date column (for example, OrderDate), create another measure in DAX that filters sales to only the year 2011. For example:

DAX
Copy
Edit
Total Sales 2011 =
CALCULATE(
    SUM(FactResellerSales[SalesAmount]),
    YEAR(FactResellerSales[OrderDate]) = 2011
)
Note:

If your table does not have a proper date column, consider joining a Date dimension table or converting an OrderDateKey into a date.

Once created, you can use this measure in your matrix (or another visual) to show the refined sales results.

5. Add a New Column in DimReseller for Employee Count
In the DimReseller table, add a calculated column (again using DAX) to indicate if a reseller has more than 50 employees. For example, if the table has a column named EmployeeCount, use:

DAX
Copy
Edit
EmployeeStatus = 
IF(
    DimReseller[EmployeeCount] > 50,
    "Has more than 50 employees",
    "Does not have over 50 employees"
)
This column will now show one of the two text values based on each reseller’s employee count.

6. Screenshot for Participation Credit
In Power BI Desktop, switch to the Data view.

Navigate to the DimReseller table.

In the formula bar, you should see the DAX expression for the new calculated column (the “name = function” section).

Also, review a few rows of the new EmployeeStatus column so the results are visible.

Capture a screenshot showing both the formula bar (with your DAX code) and the results of the column.

Paste this screenshot into your discussion forum as required for participation credit.


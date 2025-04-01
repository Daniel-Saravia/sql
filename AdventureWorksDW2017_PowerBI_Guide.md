# Power BI Project: Analyzing Reseller Sales in AdventureWorksDW2017

## 1. Import Tables Using Power Query M Code

Replace `YourServerName` with the actual name of your SQL Server instance.

### FactResellerSales

```m
let
    Source = Sql.Database("YourServerName", "AdventureWorksDW2017"),
    FactResellerSales = Source{[Schema="dbo",Item="FactResellerSales"]}[Data]
in
    FactResellerSales
```

### DimProduct

```m
let
    Source = Sql.Database("YourServerName", "AdventureWorksDW2017"),
    DimProduct = Source{[Schema="dbo",Item="DimProduct"]}[Data]
in
    DimProduct
```

### DimReseller

```m
let
    Source = Sql.Database("YourServerName", "AdventureWorksDW2017"),
    DimReseller = Source{[Schema="dbo",Item="DimReseller"]}[Data]
in
    DimReseller
```

## 2. Create Total Sales Measure (DAX)

In the `FactResellerSales` table, add the following DAX measure:

```dax
Total Sales = SUM(FactResellerSales[SalesAmount])
```

## 3. Create Matrix View

- Add a **Matrix** visual in the report view.
- **Rows:** Add `ResellerName` from `DimReseller`.
- **Values:** Add the `Total Sales` measure.

This matrix will now show each reseller and their corresponding total sales.

## 4. Create Sales Measure for the Year 2011

Assuming there is a date column like `OrderDate`:

```dax
Total Sales 2011 =
CALCULATE(
    SUM(FactResellerSales[SalesAmount]),
    YEAR(FactResellerSales[OrderDate]) = 2011
)
```

> ⚠️ If your table uses `OrderDateKey`, you may need to convert it to a date first.

## 5. Add Column to DimReseller Table

In the `DimReseller` table, create a new calculated column:

```dax
EmployeeStatus = 
IF(
    DimReseller[EmployeeCount] > 50,
    "Has more than 50 employees",
    "Does not have over 50 employees"
)
```

## 6. Screenshot for Discussion Forum

1. Go to the **Data** view in Power BI.
2. Open the **DimReseller** table.
3. Locate the new column `EmployeeStatus`.
4. Ensure the DAX formula (`EmployeeStatus = ...`) is visible in the formula bar.
5. Take a screenshot showing both the formula bar and some resulting values.
6. Paste the screenshot into your discussion forum for participation credit.

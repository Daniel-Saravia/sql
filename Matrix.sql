SET DATEFORMAT mdy
SELECT 
	PC.Name AS ProdCat, 
	PS.Name AS SubCat, 
	DATEPART(yy, SOH.OrderDate) AS OrderYear, 
	'Q' + DATENAME(qq, SOH.OrderDate) AS OrderQtr, 
	SUM(SOD.UnitPrice * SOD.OrderQty) AS Sales
FROM 
	Production.ProductSubcategory PS INNER JOIN
    Sales.SalesOrderHeader SOH INNER JOIN
    Sales.SalesOrderDetail SOD ON SOH.SalesOrderID = SOD.SalesOrderID INNER JOIN
    Production.Product P ON SOD.ProductID = P.ProductID ON PS.ProductSubcategoryID = P.ProductSubcategoryID INNER JOIN
    Production.ProductCategory PC ON PS.ProductCategoryID = PC.ProductCategoryID
WHERE       
	(SOH.OrderDate BETWEEN '1/1/2011' AND '12/31/2014')
GROUP BY    
	DATEPART(yy, SOH.OrderDate), PC.Name, PS.Name, 'Q' + DATENAME(qq, SOH.OrderDate), PS.ProductSubcategoryID

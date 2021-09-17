 

--Assignment Day2 –SQL:  Comprehensive practice 

--Answer following questions 

--    What is a result set? 

--	Result set is the rows from the data base that is returned from a query.

--    What is the difference between Union and Union All? 

--	UNION is used to join the result sets of 2 queries. The rows must come from the same columns. UNION ALL joins all the rows from 2 tables.

--    What are the other Set Operators SQL Server has? 

--	INTERSECT takes rows that are common to both tables. EXCEPT takes rows that appears in the first table but not the second;

--    What is the difference between Union and Join? 

--	JOIN combines columes, UNION combines rows. 

--    What is the difference between INNER JOIN and FULL JOIN? 

--	INNER JOIN tables only the matching data from both tables, FULL JOIN all the data from both tables. 

--    What is difference between left join and outer join 

--	They are the same thing

--    What is cross join? 

--	CROSS JOIN returns a cartesian product of the 2 tables. 

--    What is the difference between WHERE clause and HAVING clause? 

--	WHERE filters rows before grouping, HAVING exclude records after grouping.

--    Can there be multiple group by columns? 

--  Yes

--Write queries for following scenarios 

USE AdventureWorks2019;

--    How many products can you find in the Production.Product table? 

SELECT COUNT(ProductID) AS 'COUNT'
FROM Production.Product;

--    Write a query that retrieves the number of products in the Production.Product table that are included in a subcategory. The rows that have NULL in column ProductSubcategoryID are considered to not be a part of any subcategory. 

SELECT COUNT(ProductID) AS 'COUNT'
FROM Production.Product
WHERE ProductSubcategoryID IS NOT NULL;

--    How many Products reside in each SubCategory? Write a query to display the results with the following titles. 

--ProductSubcategoryID CountedProducts 

SELECT ProductSubcategoryID, COUNT(ProductID) AS 'CountedProducts'
FROM Production.Product
WHERE ProductSubcategoryID IS NOT NULL
GROUP BY ProductSubcategoryID;

---------------------- --------------- 

--    How many products that do not have a product subcategory.  

SELECT ProductSubcategoryID, COUNT(ProductID) AS 'Counted Products'
FROM Production.Product
WHERE ProductSubcategoryID IS NULL
GROUP BY ProductSubcategoryID;

--    Write a query to list the summary of products quantity in the Production.ProductInventory table. 

SELECT COUNT(Quantity) AS 'COUNT', SUM(Quantity) AS 'Total', MAX(Quantity) AS 'MAX', MIN(Quantity) AS 'MIN', AVG(Quantity) AS 'Average'
FROM Production.ProductInventory;

--     Write a query to list the summary of products in the Production.ProductInventory table and LocationID set to 40 and limit the result to include just summarized quantities less than 100. 

--              ProductID    TheSum 

SELECT ProductID, Quantity AS 'TheSum'
FROM Production.ProductInventory
WHERE LocationID = '40'
AND Quantity < 100;

-------------        ---------- 

--    Write a query to list the summary of products with the shelf information in the Production.ProductInventory table and LocationID set to 40 and limit the result to include just summarized quantities less than 100 

--Shelf      ProductID    TheSum 

SELECT Shelf, ProductID, Quantity AS 'TheSum'
FROM Production.ProductInventory
WHERE LocationID = '40'
AND Quantity < 100;

------------ -----------        ----------- 

--    Write the query to list the average quantity for products where column LocationID has the value of 10 from the table Production.ProductInventory table. 

SELECT AVG(Quantity) AS 'TheAvg'
FROM Production.ProductInventory
WHERE LocationID = '10';

--    Write query  to see the average quantity  of  products by shelf  from the table Production.ProductInventory 

--ProductID   Shelf      TheAvg 

SELECT ProductID, Shelf, AVG(Quantity) AS 'TheAvg'
FROM Production.ProductInventory
GROUP BY Shelf, ProductID
ORDER BY Shelf;

------------- ---------- ----------- 

--    Write query  to see the average quantity  of  products by shelf excluding rows that has the value of N/A in the column Shelf from the table Production.ProductInventory 

--ProductID   Shelf      TheAvg 

SELECT ProductID, Shelf, AVG(Quantity) AS 'TheAvg'
FROM Production.ProductInventory
WHERE Shelf <> 'N/A'
GROUP BY Shelf, ProductID
ORDER BY Shelf;

------------- ---------- ----------- 

--    List the members (rows) and average list price in the Production.Product table. This should be grouped independently over the Color and the Class column. Exclude the rows where Color or Class are null. 

--Color           	Class 	TheCount   	AvgPrice 

SELECT Color, Class, COUNT(ProductID) AS 'TheCount', AVG(ListPrice) AS 'TheAvg'
FROM Production.Product
WHERE Color IS NOT NULL
AND Class IS NOT NULL
GROUP BY Class, Color;

----------------	- ----- 	----------- 	--------------------- 

--Joins: 

--      Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables. Join them and produce a result set similar to the following.  

SELECT c.Name AS 'Country', s.Name AS 'Province'
FROM Person.CountryRegion c LEFT JOIN Person.StateProvince s
ON c.CountryRegionCode = s.CountryRegionCode;

--Country                        Province 

-----------                          ---------------------- 


--    Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables and list the countries filter them by Germany and Canada. Join them and produce a result set similar to the following. 

SELECT c.Name AS 'Country', s.Name AS 'Province'
FROM Person.CountryRegion c LEFT JOIN Person.StateProvince s
ON c.CountryRegionCode = s.CountryRegionCode
WHERE c.Name IN ('Germany','Canada');

--Country                        Province 

-----------                          ---------------------- 

--        Using Northwnd Database: (Use aliases for all the Joins) 
USE Northwind;
--    List all Products that has been sold at least once in last 25 years. 
SELECT DISTINCT(p.ProductName)
FROM Orders o 
LEFT JOIN [Order Details] d ON o.OrderID = d.OrderID
LEFT JOIN Products p on d.ProductID = p.ProductID
WHERE o.OrderDate < '1996-9-16';
--    List top 5 locations (Zip Code) where the products sold most. 
SELECT TOP 5 COUNT(od.ProductID) AS 'Product Sold', o.ShipPostalCode AS 'Zip Code'
FROM Orders o
INNER JOIN [Order Details] od
ON od.OrderID = o.OrderID
WHERE o.ShipPostalCode IS NOT NULL
GROUP BY o.ShipPostalCode
ORDER BY 'Product Sold' DESC;
--    List top 5 locations (Zip Code) where the products sold most in last 20 years. 
SELECT TOP 5 COUNT(od.ProductID) AS 'Product Sold', o.ShipPostalCode AS 'Zip Code'
FROM Orders o
INNER JOIN [Order Details] od
ON od.OrderID = o.OrderID
WHERE o.ShipPostalCode IS NOT NULL
AND o.OrderDate > '2001-9-16'
GROUP BY o.ShipPostalCode
ORDER BY 'Product Sold' DESC;
--     List all city names and number of customers in that city.      
SELECT COUNT(CustomerID ) AS 'TheCount', City 
FROM Customers
GROUP BY City
ORDER BY 'TheCount' DESC;
--    List city names which have more than 10 customers, and number of customers in that city  
SELECT COUNT(CustomerID ) AS 'TheCount', City 
FROM Customers
WHERE City LIKE '__________%'
GROUP BY City
ORDER BY 'TheCount' DESC;
--    List the names of customers who placed orders after 1/1/98 with order date. 
SELECT DISTINCT(c.CompanyName)
FROM Customers c 
INNER JOIN Orders o
ON o.CustomerID = c.CustomerID
WHERE o.OrderDate > '1998-1-1';
--    List the names of all customers with most recent order dates  
SELECT c.CompanyName, c.ContactName
FROM Customers c 
LEFT JOIN Orders o
ON o.CustomerID = c.CustomerID
ORDER BY o.OrderDate;
--    Display the names of all customers  along with the  count of products they bought  
SELECT c.ContactName, COUNT(DISTINCT(od.ProductID))
FROM Customers c 
LEFT JOIN Orders o
ON o.CustomerID = c.CustomerID
LEFT JOIN [Order Details] od
ON o.OrderID = od.OrderID
GROUP BY c.ContactName;
--    Display the customer ids who bought more than 100 Products with count of products. 
SELECT DISTINCT(o.CustomerID)
FROM Orders o
LEFT JOIN [Order Details] od
ON o.OrderID = od.OrderID
WHERE  (SELECT COUNT(ProductID)
FROM [Order Details]) > 100;
--    List all of the possible ways that suppliers can ship their products. Display the results as below 

--Supplier Company Name   	Shipping Company Name 

SELECT sup.CompanyName as 'Supplier Company Name', sh.CompanyName as 'Shipper Company Name'
FROM Shippers sh
CROSS JOIN Suppliers sup;
-----------------------------------            ---------------------------------- 

--    Display the products order each day. Show Order date and Product Name. 
SELECT o.OrderDate, p.ProductName
FROM Orders o
LEFT JOIN [Order Details] od
on o.OrderID = od.OrderID
LEFT JOIN Products p 
on od.ProductID = p.ProductID
GROUP BY o.OrderDate, p.ProductName;
--    Displays pairs of employees who have the same job title. 
SELECT DISTINCT em1.FirstName AS 'EmPair1', em2.FirstName AS 'EmPair2'
FROM Employees em1
INNER JOIN Employees em2
on em1.Title = em2.Title
WHERE em1.EmployeeID < em2.EmployeeID;
--    Display all the Managers who have more than 2 employees reporting to them. 
SELECT EmployeeID
FROM Employees
WHERE (SELECT COUNT(DISTINCT em2.EmployeeID)
FROM Employees em1
LEFT JOIN Employees em2
ON em2.ReportsTo = em1.EmployeeID) > 2;
--    Display the customers and suppliers by city. The results should have the following columns 

--City  

--Name  

--Contact Name, 

--Type (Customer or Supplier) 

SELECT c.City, c.CompanyName, c.ContactName, 'Customer'
FROM Customers c
UNION ALL
SELECT s.City, s.CompanyName, s.ContactName, 'Supplier'
FROM Suppliers s;

--GOOD  LUCK. 

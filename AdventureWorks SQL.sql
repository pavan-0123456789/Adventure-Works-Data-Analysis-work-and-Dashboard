-- [roduct merge 
SELECT
    p.ProductKey,
    p.EnglishProductName,
    p.ListPrice,
    p.StandardCost,
    sc.EnglishProductSubcategoryName,
    c.EnglishProductCategoryName
FROM dim_product2 p
LEFT JOIN dimprodsubcategory sc
    ON CAST(p.ProductSubcategoryKey AS SIGNED) = sc.ProductSubcategoryKey
LEFT JOIN dimprodcategory c
    ON sc.ProductCategoryKey = c.ProductCategoryKey;
    
SELECT COUNT(*) FROM `0)sales` ;
SELECT COUNT(*) FROM dim_product2 ;
SELECT COUNT(*) FROM dimcustomer ;
SELECT COUNT(*) FROM dimdate ;
SELECT COUNT(*) FROM dimprodcategory ;
-- -------------------------------------------

SELECT *, p.EnglishProductName AS ProductName
FROM `0)sales` s
LEFT JOIN dim_product2 p
    ON s.ProductKey = p.ProductKey;
    
SELECT COUNT(*) 
FROM `0)sales` 

-- -------------------------------------
SELECT
    s.*,
    CONCAT(c.FirstName, ' ', c.LastName) AS CustomerFullName,
    p.`Unit price` AS ProductUnitPrice
FROM `0)sales` s
LEFT JOIN dimcustomer c
    ON s.CustomerKey = c.CustomerKey
LEFT JOIN dim_product2 p
    ON s.ProductKey = p.ProductKey;
-- ---------------------------------------------------

-- Q:3.calcuate the following fields from the Orderdatekey field ( First Create a Date Field from Orderdatekey)
-- A year
SELECT
YEAR(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) AS Year
FROM `0)sales`;

-- B) MONTH NUMBER
SELECT MONTH(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) AS MonthNo
FROM `0)sales`;
-- C)Month Full Name
SELECT MONTHNAME(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) AS MonthName
FROM `0)sales`;
-- D)Quarter(Q1,Q2,Q3,Q4)
SELECT
    CONCAT('Q', QUARTER(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d'))) AS Quarter
FROM `0)sales`; 
 -- E)Year Month(YYYY-MMM)
SELECT
    DATE_FORMAT(
        STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d'),
        '%Y-%b'
    ) AS YearMonth
FROM `0)sales`;

-- F)weekday no
SELECT
    WEEKDAY(
        STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')
    ) + 1 AS WeekDayNo
FROM `0)sales`;
-- G) WeekDayName
SELECT
    DAYNAME(
        STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')
    ) AS WeekDayName
FROM `0)sales`;
-- H) FinancialMonth
SELECT
    CASE
        WHEN MONTH(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) >= 4
        THEN MONTH(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) - 3
        ELSE MONTH(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) + 9
    END AS FinancialMonth
FROM `0)sales`;

-- I) Financial Quarter
SELECT
    CASE
        WHEN MONTH(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) BETWEEN 4 AND 6 THEN 'Q1'
        WHEN MONTH(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) BETWEEN 7 AND 9 THEN 'Q2'
        WHEN MONTH(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) BETWEEN 10 AND 12 THEN 'Q3'
        ELSE 'Q4'
    END AS FinancialQuarter
FROM `0)sales`;


-- Q4)Calculate the Sales amount uning the columns(unit price,order quantity,unit discount)
SELECT
    OrderQuantity,
    UnitPrice,
    DiscountAmount,
    (UnitPrice * OrderQuantity) - DiscountAmount AS CalculatedSalesAmount
FROM `0)sales`;

-- --------------------------------------------------------------------

SELECT
    OrderQuantity, SalesAmount
    ProductStandardCost,
    OrderQuantity * UnitPrice AS ProductionCost
FROM `0)sales`;
-- --------------------------------------------------------------------

SELECT SalesAmount, ProductKey, TotalProductCost, SalesAmount - ProductStandardCost AS Profit
FROM `0)sales`;
-- ------------------------------------------------------------------------
SELECT
    YEAR(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) AS Year,
    SUM(SalesAmount) AS TotalSales
FROM `0)sales`
GROUP BY Year
ORDER BY Year;

-- --------------------------------------------------------------

SELECT
    MONTHNAME(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) AS MonthName,
    SUM(SalesAmount) AS TotalSales
FROM `0)sales`
GROUP BY MonthName
ORDER BY MONTH(STR_TO_DATE(CONCAT('01-', MonthName, '-2020'), '%d-%M-%Y'));

-- ------------------------------------------------------------------
SELECT
    CONCAT('Q',
        QUARTER(
            STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')
        )
    ) AS Quarter,
    SUM(SalesAmount) AS TotalSales
FROM `0)sales`
GROUP BY Quarter;
-- ---------------------------------------------------------------------
SELECT YEAR(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) AS Year,
	SUM(SalesAmount) AS TotalSales,
    SUM(TotalProductCost) AS TotalProductionCost
FROM `0)sales`
GROUP BY Year
ORDER BY Year;
-- ---------------------------------------------------------------------
-- Top 10 Products by Sales
SELECT p.EnglishProductName, SUM(s.SalesAmount) AS TotalSales
FROM `0)sales` s
JOIN dim_product2 p
    ON s.ProductKey = p.ProductKey
GROUP BY p.EnglishProductName
ORDER BY TotalSales DESC 
LIMIT 10;

-- Top 10 Customers by Sales
SELECT CONCAT(c.FirstName,' ',c.LastName) AS CustomerName, SUM(s.SalesAmount) AS TotalSales
FROM`0)sales` s JOIN dimcustomer c ON s.CustomerKey = c.CustomerKey
GROUP BY CustomerName
ORDER BY TotalSales DESC
LIMIT 5;

-- Sales by Region
SELECT SalesTerritoryKey, SUM(SalesAmount) AS TotalSales
FROM `0)sales`
GROUP BY SalesTerritoryKey
ORDER BY TotalSales DESC;


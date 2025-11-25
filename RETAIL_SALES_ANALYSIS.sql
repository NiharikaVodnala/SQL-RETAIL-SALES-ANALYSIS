--Retail Sales Analysis

create database RSA

use RSA



-- Creating a Table
Create Table Retail_Sales
(
	transactions_id INT PRIMARY KEY,
	sale_date Date,
	sale_time Time,
	customer_id INT,
	gender VARCHAR(15),
	age INT,
	category VARCHAR(11),
	quantiy INT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT
)

SELECT * FROM Retail_Sales




-- DIRECTLY IMPORT THE EXCEL OR BULK INSERT 
BULK INSERT dbo.Retail_Sales
FROM 'E:\Learning\SQL projects\Retail-Sales-Analysis-SQL-Project--P1\Retail Sales Analysis_utf.csv'       -- path on the SQL Server machine
WITH (
  FIRSTROW = 2,                   -- skip header row if present
  FIELDTERMINATOR = ',', 
  ROWTERMINATOR = '\n',
  TABLOCK
);

SELECT * FROM Retail_Sales



--TOTAL RECORDS
SELECT COUNT(*) FROM Retail_Sales



--DATA CLEANING
SELECT * FROM RETAIL_SALES
WHERE quantiy IS NULL OR
price_per_unit	IS NULL OR
cogs IS NULL OR
total_sale IS NULL 


DELETE FROM Retail_Sales
WHERE quantiy IS NULL OR
price_per_unit	IS NULL OR
cogs IS NULL OR
total_sale IS NULL 


SELECT * FROM Retail_Sales



--DATA EXPLORATION

-- Q1: WAQ TO FIND NO OF SALES
SELECT COUNT(*)[COUNT]
FROM Retail_Sales


-- Q2: WAQ TO FIND NO OF CUSTOMERS
SELECT COUNT(DISTINCT customer_id) [NO OF CUSTOMERS]
FROM Retail_Sales


--DATA ANALYSIS AND BUSINESS KEY PROBLEMS & ANSWERS
--Write a SQL query to retrieve all columns for sales made on '2022-11-05'
SELECT * FROM Retail_Sales
WHERE sale_date='2022-11-05'


-- Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
SELECT * FROM Retail_Sales
WHERE category='Clothing' and
quantiy>2 and 
sale_date>='2022-11-01'
and sale_date<'2022-12-01'
--we cannot use format


--Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT category,SUM(total_sale) [TOTAL SALE],
count(*) as total_sale
FROM Retail_Sales
GROUP BY category

--Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT ROUND(AVG(AGE),0) AGE
FROM Retail_Sales
WHERE category='BEAUTY'



--Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT * FROM Retail_Sales
WHERE total_sale>1000



--Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT GENDER,CATEGORY,
COUNT(transactions_id) [NO OF TRANS] FROM Retail_Sales
GROUP BY GENDER,category



--Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT * FROM 
(
	SELECT MONTH(SALE_DATE) [MONTH],YEAR(sale_date) YEAR,AVG(total_sale) [AVG SALE],
	RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY AVG(TOTAL_SALE)) [RANK]
	FROM Retail_Sales
	GROUP BY MONTH(SALE_DATE),YEAR(sale_date)
	--ORDER BY YEAR(sale_date) ASC,MONTH(SALE_DATE) ASC
	--[ORDER BY CANNOT BE USED IN SUBQUERY]
) AS T1
WHERE RANK=1


--Write a SQL query to find the top 5 customers based on the highest SUM OF total sales 
SELECT TOP 5 customer_id,SUM(TOTAL_SALE) [SALES SUM]
FROM Retail_Sales
GROUP BY customer_id
ORDER BY SUM(total_sale) DESC



--Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT category,COUNT(DISTINCT customer_id) [UNI CUSTOMERS]
FROM Retail_Sales
GROUP BY category



--Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
WITH CTE AS(
	SELECT *,
	CASE 
		WHEN DATEPART(HOUR,SALE_TIME)<12 THEN 'MORNING'
		WHEN DATEPART(HOUR,SALE_TIME) BETWEEN 12 AND 17 THEN 'AFTERNOON'
		ELSE 'EVENING'
	END AS SHIFT
	FROM Retail_Sales
)

SELECT SHIFT,COUNT(transactions_id) [TOTAL HOURS]
FROM CTE
GROUP BY SHIFT

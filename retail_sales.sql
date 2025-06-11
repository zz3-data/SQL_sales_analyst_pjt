-- SQL Retail Sales Project
--Create Table
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
	(
	transactions_id INT PRIMARY KEY,
	sale_date DATE, 
	sale_time TIME,
	customer_id INT, 
	gender VARCHAR(15), 
	age INT, 
	category VARCHAR(15),
	quantity INT, 
	price_per_unit FLOAT,  
	cogs FLOAT,
	total_sale FLOAT
	);

SELECT * FROM retail_sales
limit 10;

SELECT
	count(*) 
FROM retail_sales;

--data cleaning and remove nulls
SELECT * FROM retail_sales
WHERE transactions_id is NULL

SELECT * FROM retail_sales
WHERE 
	transactions_id is NULL
	OR 
	sale_date is null
	OR 
	sale_time is null
	OR 
	customer_id is null
	OR 
	gender is null
	OR 
	age is null
	OR 
	category is null
	OR 
	quantity is null
	OR 
	price_per_unit is null
	OR 
	cogs is null
	OR 
	total_sale is null

-- delete the nulls
DELETE FROM retail_sales
WHERE 
	transactions_id is NULL
	OR 
	sale_date is null
	OR 
	sale_time is null
	OR 
	customer_id is null
	OR 
	gender is null
	OR 
	age is null
	OR 
	category is null
	OR 
	quantity is null
	OR 
	price_per_unit is null
	OR 
	cogs is null
	OR 
	total_sale is null

--data exploration
-- how many sales?
SELECT count(DISTINCT customer_id) as total_sale FROM retail_sales
SELECT count(DISTINCT category) as total_sale FROM retail_sales
SELECT DISTINCT category as total_sale FROM retail_sales

--Data Analysis

--1. retrieve data from specific day "2022-11-05"
select *
from retail_sales
where sale_date = '2022-11-05';

--2. retrieve all transactions where category is "clothing and quantity is >= 4 
	--and in the month of Nov-2022"

select 
	*
from retail_sales
where category = 'Clothing'
	AND 
	TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
	AND 
	quantity >= 4
--3. total sale for each category
SELECT 
	category, 
	SUM(total_sale) as net_sale,
	COUNT(*) as total_orders
FROM retail_sales
Group BY 1
--4. average age of customers who purchased items from "Beauty" category
SELECT 
	Round(AVG(age), 2) as avg_age
FROM retail_sales
where category = 'Beauty'
--5. all transactions where total_sale is greater than 1000
SELECT * FROM retail_sales
WHERE total_sale >= 1000
--6. total number of transactions made by each gender in each category
select 
	category, 
	gender,
	Count(*) as total_trans
FROM retail_sales
GROUP BY category, 
	gender
ORDER BY total_trans DESC
--7. average sale for each month. order by highest selling month
SELECT 
	year, 
	month, 
	avg_sale
FROM 
(
SELECT 
	EXTRACT(YEAR FROM sale_date) as year, 
	EXTRACT(MONTH FROM sale_date) as month,
	AVG(total_sale) as avg_sale,
	RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
Group BY 1, 2
) as t1
where rank = 1
--order by 1, 3 DESC 
--8. order by top 5 customers based on total sales
SELECT 
	customer_id,
	SUM(total_sale) as total_sales
FROM retail_sales
Group By 1
Order by 2 DESC
LIMIT 5
--9. find the numnber of unique customers who purchased items from each category
SELECT 
	category, 
	COUNT(DISTINCT customer_id) as diff_customers
FROM retail_sales
GROUP BY category
--10. create each shift and number of orders
WITH hourly_sale
AS
(
SELECT *,
	CASE 
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END as shift
FROM retail_sales
)
SELECT 
	shift, 
	COUNT(*) as total_orders
FROM hourly_sale
GROUP BY shift
--END OF Project

# Retail Sales Analysis SQL Project

**Project Title**: Retail Sales Analysis  

## Objectives: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: Create Table with column titles to help input the data. 

```sql
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
);
```

### 2. Data Cleaning

- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
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
```

### 3. Data Analysis & Findings

Create SQL queries to answer specific business questions:

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
```sql
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';
```

2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:
```sql
select 
	*
from retail_sales
where category = 'Clothing'
	AND 
	TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
	AND 
	quantity >= 4
```

3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
```sql
SELECT 
	category, 
	SUM(total_sale) as net_sale,
	COUNT(*) as total_orders
FROM retail_sales
Group BY 1
```

4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
```sql
SELECT 
	Round(AVG(age), 2) as avg_age
FROM retail_sales
where category = 'Beauty'
```

5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
```sql
SELECT * FROM retail_sales
WHERE total_sale > 1000
```

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
```sql
select 
	category, 
	gender,
	Count(*) as total_trans
FROM retail_sales
GROUP BY category, 
	gender
ORDER BY total_trans DESC
```

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
```sql
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
```

8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
```sql
SELECT 
	customer_id,
	SUM(total_sale) as total_sales
FROM retail_sales
Group By 1
Order by 2 DESC
LIMIT 5
```

9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
```sql
SELECT 
	category, 
	COUNT(DISTINCT customer_id) as diff_customers
FROM retail_sales
GROUP BY category
```

10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
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
```

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Author

Zach Zimmerman

## Conclusion

This project gives a basic demonstration of a sales analysis through SQL for a certain business. It helps to understand sales patterns, customer behavior, and product performance that can help to drive business decisions. 




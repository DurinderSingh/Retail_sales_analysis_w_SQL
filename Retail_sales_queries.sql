-- Retail Sales Analysis Project

-- Create Database
CREATE database retail_sales;
USE retail_sales;

-- Create Table
DROP TABLE IF EXISTS retail_sales_tb;
CREATE TABLE retail_sales_tb(
	transaction_id	INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id	INT,
    gender VARCHAR(15),
    age	INT,
    category VARCHAR(15),	
    quantiy	INT,
    price_per_unit	FLOAT,
    cogs FLOAT,
    total_sale FLOAT
                )
 
 -- To get the row count
Select COUNT(*) from retail_sales_tb;

-- Data Cleaning
SELECT * FROM retail_sales_tb
WHERE transaction_id IS NULL
	   OR
       sale_date IS NULL
       OR
       sale_time IS NULL
       OR
       customer_id IS NULL
       OR
       gender IS NULL
       OR
       age IS NULL
       OR
       category IS NULL
       OR
       quantiy IS NULL
       OR
       price_per_unit IS NULL
       OR
       cogs IS NULL
       OR
       total_sale IS NULL;
       
DELETE FROM retail_sales_tb
WHERE transaction_id IS NULL
	   OR
       sale_date IS NULL
       OR
       sale_time IS NULL
       OR
       customer_id IS NULL
       OR
       gender IS NULL
       OR
       age IS NULL
       OR
       category IS NULL
       OR
       quantiy IS NULL
       OR
       price_per_unit IS NULL
       OR
       cogs IS NULL
       OR
       total_sale IS NULL;
       
       
-- Data Exploration 

-- How many sales we have?
SELECT COUNT(*) as total_sale from retail_sales_tb;

-- How many unique customers do we have?
SELECT COUNT(DISTINCT customer_id) as total_sale from retail_sales_tb;

-- Which unique categories we have?
Select DISTINCT category from retail_sales_tb;


-- -----------------  Data Analysis & Key Business Problems & Answers  -----------------

-- Q1: Write a SQL query to retrieve all columns for sales made on '2022-11-05'
-- Q2: Write a SQL query to retrieve all transactions where the category is 'clothing' and the quantity sold is more than 10 in the month of Nov-2022.
-- Q3: Write a SQL query to calculate the total sales(total_sales) for each category.
-- Q4: Write a SQL query to find the average age of customers who purchased items form the 'Beauty' category.
-- Q5: Write a SQL query to all transactions where the total_sales is greate than 1000.
-- Q6: Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q7: Write a SQL query to calculate the average sale for each month. Find out best selling months in each year.
-- Q8: Write a SQL query to find the top 5 customers based on the highest total sales.
-- Q9: Write a SQL query to the number of unique customers who purchased items from each category.
-- Q10: Write a SQL query to create each shify and number of orders (Examople Morning <= 12, afternoon between 12 & 17, Evening > 17)

-- ------------------------------------------My analysis and findings -------------------------------------

-- Q1: Write a SQL query to retrieve all columns for sales made on '2022-11-05'
SELECT * FROM retail_sales_tb
WHERE sale_date = '2022-11-05';


-- Q2: Write a SQL query to retrieve all transactions where the category is 'clothing' and the quantity sold is more than 4 in the month of Nov-2022.
SELECT *
FROM retail_sales_tb
WHERE category = 'clothing'
  AND quantity >=4
  AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11';


-- Q3: Write a SQL query to calculate the total sales(total_sales) for each category.
SELECT category, SUM(total_sale) as net_sale, COUNT(*) as total_orders
FROM retail_sales_tb
GROUP BY category;


-- Q4: Write a SQL query to find the average age of customers who purchased items form the 'Beauty' category.
SELECT ROUND(AVG(age),2) as avg_age
FROM retail_sales_tb
where category ='Beauty';

-- Q5: Write a SQL query to all transactions where the total_sales is greate than 1000.
SELECT * 
FROM retail_sales_tb
WHERE total_sale >1000;


-- Q6: Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT category, gender, COUNT(*) as total_trans
FROM retail_sales_tb
GROUP BY category, gender
ORDER BY 1;


-- Q7: Write a SQL query to calculate the average sale for each month. Find out best selling months in each year.
SELECT sale_month, sale_year, avg_total_sale
FROM
(
    SELECT  YEAR(sale_date) AS sale_year, 
            MONTH(sale_date) AS sale_month,
            ROUND(AVG(total_sale), 2) AS avg_total_sale,
            RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) AS rank_position
    FROM retail_sales_tb
    GROUP BY sale_year, sale_month
) AS t1 
WHERE rank_position = 1;


-- Q8: Write a SQL query to find the top 5 customers based on the highest total sales.
SELECT customer_id, SUM(total_sale) as total_sale
FROM retail_sales_tb
GROUP BY customer_id
ORDER BY total_sale DESC
LIMIT 5;


-- Q9: Write a SQL query to the number of unique customers who purchased items from each category.
SELECT category, COUNT(DISTINCT customer_id) as unique_customers
FROM retail_sales_tb
GROUP BY category;


-- Q10: Write a SQL query to create each shify and number of orders (Examople Morning <= 12, afternoon between 12 & 17, Evening > 17)

WITH hourly_sale
AS
(
SELECT * ,
	CASE
		WHEN HOUR(sale_time) < 12 THEN 'Morning'
        WHEN HOUR(sale_time) BETWEEN 12 and 17 THEN 'Afternoon'
        ELSE 'Evening'
	END as shift
FROM retail_sales_tb
)
SELECT shift, COUNT(*) as total_orders
FROM hourly_sale
GROUP BY shift;


-- ------------------------- END OF THE PROJECT ------------------------------
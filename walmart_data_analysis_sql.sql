CREATE TABLE sales(
invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
branch VARCHAR(5) NOT NULL,
city VARCHAR(30) NOT NULL,
customer_type VARCHAR(30) NOT NULL,
gender VARCHAR(10) NOT NULL,
product_line VARCHAR(100) NOT NULL,
unit_price DECIMAL(10,2) NOT NULL,
quantity int NOT NULL,
VAT FLOAT(6,4) NOT NULL,
total DECIMAL(10,2) NOT NULL,
date DATETIME  NOT NULL,
time TIME NOT NULL,
payment_method VARCHAR(15) NOT NULL,
cog DECIMAL(10,2) NOT NULL,
gross_margin_pct FLOAT(11,9),
gross_income DECIMAL(12,4) NOT NULL,
rating FLOAT(2,1)
);
select* from sales;


-- ----------------------------------------------------------------------------------
-- --------------FEATURE ENGINEERING--------------------------------------------------
-- ----time_of_day
SELECT
 time,
 (  CASE
        WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'MORNING'
        WHEN time BETWEEN '12:00:01' AND '16:00:00' THEN 'AFTERNOON'
        ELSE 'EVENING'
 END ) AS time_of_day
FROM sales;

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(30);
UPDATE sales
SET time_of_day = (
 CASE
        WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'MORNING'
        WHEN time BETWEEN '12:00:01' AND '16:00:00' THEN 'AFTERNOON'
        ELSE 'EVENING'
 END
);

SELECT*FROM sales;

-- ----day_name
-- ---------------------------------------------------------------------------------------
SELECT 
date,
DAYNAME(date) AS day_name
FROM sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(30);
UPDATE sales
SET
day_name =
(
DAYNAME(date)
);

SELECT * FROM sales;

-- ----month_name
-- -------------------------------------------------------------------------------------
SELECT date,
MONTHNAME(date) as month_name
FROM sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(30);

UPDATE sales
SET month_name = 
(
MONTHNAME(date)
);

select * from sales;
-- ---------------------------------------------------------------------------------------------
-- -------------------generic qurestions about dataset-------------------------------------------

-- How many unique cities does the data have?

SELECT 
DISTINCT city 
FROM sales;

-- In which city is each branch?

SELECT 
DISTINCT branch
FROM sales;

SELECT 
DISTINCT city,branch
FROM sales;

-- ------------------------------------------------------------------------------
-- -------------product questions about walmart dataset----------------------------

-- How many unique prodct line does data  have?
SELECT 
COUNT(DISTINCT  product_line ) AS num_of_product_line
FROM sales;

-- What is a most common payment method ?
SELECT 
payment_method,
COUNT(payment_method) AS cnt
FROM sales
GROUP BY payment_method
ORDER BY cnt DESC;

-- What is a most selling product_line?
SELECT
product_line, 
COUNT(product_line ) as cnt_pro
FROM sales
GROUP BY product_line
ORDER BY cnt_pro DESC;

-- What is a total revenue by month?

SELECT 
month_name AS month,
SUM(total) AS revenue
FROM sales
GROUP BY month
ORDER BY revenue DESC;

-- What month have largest COGS?
SELECT
month_name as month,
SUM(cog) AS largest_cogs
FROM sales
GROUP BY month
ORDER BY largest_cogs DESC;

-- What a product_line as a largest revenue?
SELECT 
product_line,
SUM(total) AS revenue 
FROM sales
GROUP BY product_line
ORDER BY revenue DESC;

-- What is a city with largest revenue?
SELECT 
branch,
city,
SUM(total) as revenue
FROM sales
GROUP BY branch,city
ORDER BY revenue DESC;

-- What is a product_line as largest VAT?
SELECT
product_line,
AVG(VAT) AS new_vat
FROM sales
GROUP BY product_line
ORDER BY new_vat DESC;

-- which branch sold more products than average product sold?
SELECT 
branch,
SUM(quantity) as qty
FROM sales
GROUP BY branch
HAVING SUM(quantity)>(SELECT AVG(quantity)
FROM sales);

-- What is a most common product line by gender ?
SELECT 
product_line ,
gender,
COUNT(gender) AS total_cnt
FROM sales
GROUP BY product_line,gender
ORDER BY total_cnt DESC;

-- What is a average rating of each product line?
SELECT 
product_line,
-- rounding upto 2 decimal places
ROUND(AVG(rating),2) AS new_rate
FROM sales
GROUP BY product_line
ORDER BY new_rate DESC;

-- -------------------------------------------------------------------------------------------------
-- -----------------------Sales questions on walmart dataset-----------------------------------------

-- Numbers of sales made in each  day ?
SELECT
day_name,
SUM(total) AS ttl_sales
FROM sales
GROUP BY day_name
ORDER BY ttl_sales DESC;

-- Which of the customer types bring more revenue?
SELECT
customer_type,
SUM(total) AS REVENUE
FROM sales
GROUP BY customer_type
ORDER BY REVENUE DESC;

-- Which city has largest tax percent/ value added tax (VAT)?

SELECT
city,
AVG(VAT) AS tax_per
FROM sales
GROUP BY city
ORDER BY tax_per DESC;

-- Which customer types pays most VAT?
SELECT
customer_type,
ROUND(AVG(VAT),2) as new_vat
FROM sales
GROUP BY customer_type
ORDER BY new_vat DESC;
-- ---------------------------------------------------------------------------------------------------
-- ---------------------------CUSTOMERS ---------------------------------------------------------------
-- How many unique customers types does the data have ?
SELECT
DISTINCT customer_type
FROM sales;

-- How many unique payment method does the data have?
SELECT 
DISTINCT payment_method
FROM sales;

-- What is a most common customer type?
SELECT
DISTINCT customer_type
FROM sales;

-- Which customer types buys most?
SELECT
DISTINCT customer_type,
COUNT(*) AS buys
FROM sales
GROUP BY customer_type
ORDER BY buys;

-- What is a gender of most customers?
SELECT
gender,-- -we also use COUNT(*) where * represent gender 
COUNT(gender) as most_type_customer
FROM sales
GROUP BY gender;

-- What is a gender distribution per branch?
SELECT
gender,
COUNT(gender) as most_type_customer
FROM sales
WHERE branch = 'B'
GROUP BY gender,branch
ORDER BY most_type_customer;

-- Which time of day customers give more ratings?
SELECT
time_of_day,
AVG(rating) AS NEW
FROM sales
GROUP BY time_of_day
ORDER BY NEW DESC;

-- Which time of a day do customers gives most rating per branch?
SELECT
time_of_day,branch,
AVG(rating) AS new_rating
FROM sales
WHERE branch = 'B'
GROUP BY time_of_day,branch
ORDER BY new_rating;

-- Which day of week has the best average rating?
SELECT
day_name,branch,
AVG(rating) AS new_rating
FROM sales
GROUP BY day_name
ORDER BY new_rating DESC;

-- Which day of week hast average rating per branch?
SELECT
day_name,
AVG(rating) AS new_rating
FROM sales
WHERE branch = 'B'
GROUP BY day_name
ORDER BY new_rating;






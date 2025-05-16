-- Create Table
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
		(
			transactions_id	INT PRIMARY KEY,
			sale_date DATE,
			sale_time TIME, 
			customer_id	INT,
			gender VARCHAR(15),
			age INT,	
			category VARCHAR(15),
			quantiy INT,
			price_per_unit FLOAT,
			cogs FLOAT,     -- cogs is purchasing cost
			total_sale FLOAT
		);

select * from retail_sales
limit 10;

-- Data Cleaning
select * from retail_sales
where 
	transactions_id IS NULL
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

-- Deleting Null values

Delete From retail_sales
where 
	transactions_id IS NULL
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


select count(*) from retail_sales

--Data Exploration

--How many sales we have
select count(*) as total_sales 
from retail_sales;

--How many unique customers we have
select count( DISTINCT customer_id) as total_customers
from retail_sales;

--unique category
select distinct category
from retail_sales
order by category asc;

select * from retail_sales;

--Data Analysis and Business Key problems and answers
--1.Write a SQL query to retrieve all columns for sales made on '2022-11-05:
select * from retail_sales
where sale_date = '2022-11-05';

--2.Write a SQL query to retrieve all transactions where the category is 'Clothing' 
  --and the quantity sold is more than 4 in the month of Nov-2022:

select * from retail_sales
where category = 'Clothing'
AND TO_CHAR(sale_date , 'YYYY-MM') = '2022-11'
AND quantiy >= 4;

--3.Write a SQL query to calculate the total sales (total_sale) for each category.
select category, sum(total_sale) as total_sales, count(*) as total_orders
from retail_sales
group by category;


--4.Write a SQL query to find the average age of customers who purchased items 
  --from the 'Beauty' category.
select round(AVG(age),2) as avg_age_customers, category
from retail_sales
where category = 'Beauty'
group by category;

--5.Write a SQL query to find all transactions where the total_sale is greater than 1000.
select * from retail_sales
where total_sale >1000;

--6. Write a SQL query to find the total number of transactions (transaction_id) 
  --made by each gender in each category.
select count(*) as total_no_of_transactions, gender, category
from retail_sales
group by gender, category
order by 1

--7. Write a SQL query to calculate the average sale for each month. 
	--Find out best selling month in each year
select Year, Month, avg_sale
From(
	select 
		EXTRACT(year from sale_date) as Year,
		EXTRACT(month from sale_date) as Month,
		AVG(total_sale) as avg_sale,
		Rank() over (Partition by EXTRACT(year from sale_date) order by AVG(total_sale) DESC ) as rank
		from retail_sales
		group by 1,2
	) as t1
WHere rank = 1


--8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
select customer_id, sum(total_sale) as total_sales
from retail_sales
group by 1
order by 2 desc
limit 5

--9. Write a SQL query to find the number of unique customers who purchased 
  --items from each category
select count(Distinct customer_id) as no_of_unique_customers, category
from retail_sales
group by category

--10.Write a SQL query to create each shift 
  --and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

With hourly_sales
as
(select *,
	CASE
		WHEN EXTRACT(Hour from sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT(Hour from sale_time) Between 12 and 17 THEN 'Afternoon'
		ELSE 'Evening'
	END as shift
from retail_sales
)
select shift, count(*) as total_orders
from hourly_sales
group by shift


--end of project

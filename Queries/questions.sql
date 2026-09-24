-- This file will show me answering business questions using SQL.

-- Q1. Which cities have an average order value (Total_Amount) greater than the overall average order value of the entire dataset, and how many unique customers live there?
SELECT c.City, AVG(o.Total_Amount) AS Avg_Order_Value, COUNT(DISTINCT c.Customer_Name) AS Num_Of_Customers
FROM customer c
JOIN orders o ON o.Customer_ID = c.Customer_ID
GROUP BY c.City
HAVING AVG(o.Total_Amount) > (SELECT AVG(Total_Amount) FROM orders);

-- Q2. Which specific combinations of Category and Brand have generated the highest amount of tax revenue (Tax)?
SELECT p.Category, p.Brand, SUM(o.Tax) AS Tax_Revenue
FROM product p
JOIN orders o ON o.Product_ID = p.Product_ID
GROUP BY p.Category, p.Brand
ORDER BY SUM(o.Tax) DESC
LIMIT 5;

-- Q3. What is the total Shipping_Cost incurred for each Order_Status, broken down by the customer's Country?
SELECT c.Country, o.Order_Status, SUM(o.Shipping_Cost) AS Total_Shipping_Cost
FROM orders o
JOIN customer c ON c.Customer_ID = o.Customer_ID
GROUP BY o.Order_Status, c.Country
ORDER BY c.Country;

-- Q4. Who are the "VIP Customers"? Find the top 1% of customers based on their lifetime spending (Total_Amount), and list their names, locations, and total number of orders placed.
WITH VIP_Customer AS
(
	SELECT 
		c.Customer_Name, c.City, c.State, c.Country,
		SUM(o.Total_Amount) AS Lifetime_Spending,
		COUNT(o.Order_ID) AS Total_Order,
		PERCENT_RANK() OVER(ORDER BY SUM(o.Total_Amount) DESC) AS Percentile
	FROM customer c
	JOIN orders o ON o.Customer_ID = c.Customer_ID
	GROUP BY c.Customer_Name, c.City, c.State, c.Country
)

SELECT *
FROM VIP_Customer
WHERE Percentile <= 0.01
ORDER BY Lifetime_Spending DESC;

-- Q5. Within each product Category, what are the top 3 highest-selling Brands by volume (Quantity)?
WITH Top3_Brand AS
(
	SELECT 
		p.Category, p.Brand,
		SUM(o.Quantity) AS Total_Volume,
		ROW_NUMBER() OVER(PARTITION BY p.Category ORDER BY SUM(o.Quantity) DESC) AS Brand_Rank
	FROM product p
	JOIN orders o ON o.Product_ID = p.Product_ID
	GROUP BY p.Category, p.Brand
)

SELECT *
FROM Top3_Brand
WHERE Brand_Rank <= 3;
-- This file imports the broken down raw_amazon.csv file into three table for relational database design.

-- Create database.
CREATE DATABASE amazon;
USE amazon;

-- Create tables.
CREATE TABLE Customer
(
	Customer_ID VARCHAR(100) NOT NULL,
    Customer_Name VARCHAR(100),
    City VARCHAR(100),
    State VARCHAR(100),
    Country VARCHAR(100),
    PRIMARY KEY (Customer_ID)
);

CREATE TABLE Product
(
	Product_ID VARCHAR(100) NOT NULL,
    Product_Name VARCHAR(100),
    Category VARCHAR(100),
    Brand VARCHAR(100),
    Unit_Price DECIMAL(10,2),
    PRIMARY KEY (Product_ID)
);

CREATE TABLE Orders
(
	Order_ID VARCHAR(100) NOT NULL,
    Order_Date DATE,
    Customer_ID VARCHAR(100),
    Product_ID VARCHAR(100),
    Quantity INT,
    Discount DECIMAL(10,2),
    Tax DECIMAL(10,2),
    Shipping_Cost DECIMAL(10,2),
    Total_Amount DECIMAL(10,2),
    Payment_Method VARCHAR(100),
    Order_Status VARCHAR(100),
    Seller_ID VARCHAR(100),
    PRIMARY KEY (Order_ID),
    FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID),
    FOREIGN KEY (Product_ID) REFERENCES Product(Product_ID)
);

-- Import tables.
SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE 'C:/path/to/my/file/customer_amazon.csv'
INTO TABLE amazon.customer
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'C:/path/to/my/file/product_amazon.csv'
INTO TABLE amazon.product
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'C:/path/to/my/file/order_amazon.csv'
INTO TABLE amazon.orders
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

-- Display tables.
SELECT *
FROM customer;

SELECT *
FROM product;

SELECT *
FROM orders;
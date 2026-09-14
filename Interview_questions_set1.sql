create schema interview_questions;
use interview_questions;

-- In this section we will solve the interview questions and for each solution we need different datasets.
-- create new tables for solving the questions. 
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    city VARCHAR(50),
    signup_date DATE
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    order_status VARCHAR(20)
);

INSERT INTO customers VALUES
(1,'Ravi Kumar','Mumbai','2024-01-05'),
(2,'Anita Sharma','Delhi','2024-01-10'),
(3,'Vikram Singh','Pune','2024-01-15'),
(4,'Neha Joshi','Bangalore','2024-02-01'),
(5,'Suresh Rao','Chennai','2024-02-10'),
(6,'Priya Nair','Hyderabad','2024-02-15'),
(7,'Amit Verma','Mumbai','2024-03-01'),
(8,'Kavita Desai','Delhi','2024-03-05');

INSERT INTO orders VALUES
(101,1,'2024-01-20','DELIVERED'),
(102,2,'2024-01-25','DELIVERED'),
(103,1,'2024-02-05','CANCELLED'),
(104,4,'2024-02-10','DELIVERED'),
(105,5,'2024-02-20','DELIVERED');


-- Find customers who have never placed an order.
SELECT c.customer_id, c.customer_name
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- Find the average delivery time (in minutes) per restaurant.

drop table orders;
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    restaurant_name VARCHAR(50),
    order_time DATETIME,
    delivery_time DATETIME  -- NULL means order is still in transit / undelivered
);

INSERT INTO orders VALUES
(1,'Spice Villa','2024-03-01 12:00:00','2024-03-01 12:45:00'),
(2,'Spice Villa','2024-03-01 13:00:00','2024-03-01 13:50:00'),
(3,'Pizza Hub','2024-03-01 12:10:00','2024-03-01 12:40:00'),
(4,'Pizza Hub','2024-03-01 13:15:00',NULL),
(5,'Pizza Hub','2024-03-01 14:00:00','2024-03-01 14:35:00'),
(6,'Curry House','2024-03-01 12:30:00','2024-03-01 13:20:00');


SELECT
    restaurant_name,
    ROUND(AVG(TIMESTAMPDIFF(MINUTE, order_time, delivery_time)), 2) AS avg_delivery_minutes
FROM orders
GROUP BY restaurant_name
ORDER BY avg_delivery_minutes;


-- Show each customer's running wallet balance after every transaction.

CREATE TABLE wallet_transactions (
    txn_id INT PRIMARY KEY,
    customer_id INT,
    txn_date DATE,
    txn_type VARCHAR(10),   -- CREDIT or DEBIT
    amount DECIMAL(10,2)
);

INSERT INTO wallet_transactions VALUES
(1,1,'2024-01-01','CREDIT',1000.00),
(2,1,'2024-01-03','DEBIT',200.00),
(3,1,'2024-01-05','CREDIT',500.00),
(4,1,'2024-01-07','DEBIT',300.00),
(5,2,'2024-01-01','CREDIT',2000.00),
(6,2,'2024-01-04','DEBIT',700.00);



SELECT
    customer_id,
    txn_date,
    txn_type,
    amount,
    SUM(
        CASE
            WHEN txn_type = 'CREDIT' THEN amount
            WHEN txn_type = 'DEBIT'  THEN -amount
            ELSE 0
        END
    ) OVER (PARTITION BY customer_id ORDER BY txn_date) AS running_balance
FROM wallet_transactions;


-- Find the number of distinct active users per month.

CREATE TABLE watch_history (
    watch_id INT PRIMARY KEY,
    user_id INT,
    content_id INT,
    watch_date DATE
);

INSERT INTO watch_history VALUES
(1,1,101,'2024-01-05'),
(2,2,102,'2024-01-10'),
(3,1,103,'2024-01-20'),
(4,3,101,'2024-02-01'),
(5,1,104,'2024-02-15'),
(6,4,105,'2024-02-20'),
(7,2,101,'2024-03-01'),
(8,3,103,'2024-03-05');


SELECT
    DATE_FORMAT(watch_date, '%Y-%m') AS month,
    COUNT(DISTINCT user_id) AS active_users
FROM watch_history
GROUP BY DATE_FORMAT(watch_date, '%Y-%m')
ORDER BY month;


-- Find the trip cancellation rate for each city.
CREATE TABLE trips (
    trip_id INT PRIMARY KEY,
    city VARCHAR(30),
    rider_id INT,
    driver_id INT,
    trip_status VARCHAR(20)  -- COMPLETED, CANCELLED_BY_RIDER, CANCELLED_BY_DRIVER
);

INSERT INTO trips VALUES
(1,'Mumbai',1,10,'COMPLETED'),
(2,'Mumbai',2,11,'CANCELLED_BY_RIDER'),
(3,'Mumbai',3,10,'COMPLETED'),
(4,'Mumbai',4,12,'CANCELLED_BY_DRIVER'),
(5,'Delhi',5,13,'COMPLETED'),
(6,'Delhi',6,14,'COMPLETED'),
(7,'Delhi',7,13,'CANCELLED_BY_RIDER'),
(8,'Pune',8,15,'COMPLETED');


SELECT
    city,
    COUNT(*) AS total_trips,
    SUM(CASE WHEN trip_status LIKE 'CANCELLED%' THEN 1 ELSE 0 END) AS cancelled_trips,
    ROUND(
        SUM(CASE WHEN trip_status LIKE 'CANCELLED%' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS cancellation_rate_pct
FROM trips
GROUP BY city
ORDER BY cancellation_rate_pct DESC;


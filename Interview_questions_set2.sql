-- Find rooms that have overlapping (double-booked) bookings.

CREATE TABLE bookings (
    booking_id INT PRIMARY KEY,
    room_id INT,
    guest_name VARCHAR(50),
    check_in DATE,
    check_out DATE
);

INSERT INTO bookings VALUES
(1,101,'Ravi Kumar','2024-04-01','2024-04-05'),
(2,101,'Anita Sharma','2024-04-04','2024-04-08'),
(3,102,'Vikram Singh','2024-04-01','2024-04-03'),
(4,102,'Neha Joshi','2024-04-03','2024-04-06'),
(5,103,'Suresh Rao','2024-04-01','2024-04-02'),
(6,101,'Priya Nair','2024-04-10','2024-04-12');

SELECT
    b.room_id,
    b.booking_id  AS booking_id_1,
    b.guest_name  AS guest_1,
    b1.booking_id AS booking_id_2,
    b1.guest_name AS guest_2
FROM bookings b
JOIN bookings b1
    ON  b.room_id = b1.room_id
    AND b.booking_id < b1.booking_id
    AND b.check_in  < b1.check_out
    AND b.check_out > b1.check_in;
    

-- Find the top-selling product (by quantity) in each category.

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    category VARCHAR(30)
);

CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    product_id INT,
    quantity_sold INT,
    sale_date DATE
);

INSERT INTO products VALUES
(1,'Colgate Toothpaste','Personal Care'),
(2,'Dove Soap','Personal Care'),
(3,'Tata Salt','Grocery'),
(4,'Aashirvaad Atta','Grocery'),
(5,'Lays Chips','Snacks'),
(6,'Kurkure','Snacks');

INSERT INTO sales VALUES
(1,1,50,'2024-01-01'),
(2,2,80,'2024-01-02'),
(3,3,120,'2024-01-03'),
(4,4,150,'2024-01-04'),
(5,5,200,'2024-01-05'),
(6,6,90,'2024-01-06'),
(7,1,30,'2024-01-07'),
(8,4,60,'2024-01-08');

WITH total_quantity_sold AS (
    SELECT
        p.category,
        p.product_name,
        SUM(s.quantity_sold) AS total_qty
    FROM products p
    JOIN sales s
        ON p.product_id = s.product_id
    GROUP BY p.category, p.product_name
)
SELECT category, product_name, total_qty
FROM (
    SELECT
        category,
        product_name,
        total_qty,
        ROW_NUMBER() OVER (PARTITION BY category ORDER BY total_qty DESC) AS ranking
    FROM total_quantity_sold
) t
WHERE ranking = 1
ORDER BY total_qty;

-- Find patients who booked more than one appointment on the same day.
CREATE TABLE appointments (
    appointment_id INT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    appointment_date DATE
);

INSERT INTO appointments VALUES
(1,1,10,'2024-05-01'),
(2,1,11,'2024-05-01'),
(3,2,10,'2024-05-01'),
(4,3,12,'2024-05-02'),
(5,3,12,'2024-05-02'),
(6,4,13,'2024-05-03'),
(7,1,10,'2024-05-04');

SELECT
    patient_id,
    appointment_date,
    COUNT(*) AS appointment_count
FROM appointments
GROUP BY patient_id, appointment_date
HAVING COUNT(*) > 1;


-- Find customers who downgraded from a paid plan (BASIC/PRO) to the free plan.
CREATE TABLE subscriptions (
    subscription_id INT PRIMARY KEY,
    customer_id INT,
    plan_type VARCHAR(20),   -- FREE, BASIC, PRO
    start_date DATE,
    end_date DATE
);

INSERT INTO subscriptions VALUES
(1,1,'BASIC','2024-01-01','2024-02-01'),
(2,1,'FREE','2024-02-01',NULL),
(3,2,'PRO','2024-01-01','2024-03-01'),
(4,2,'PRO','2024-03-01',NULL),
(5,3,'FREE','2024-01-01','2024-02-01'),
(6,3,'BASIC','2024-02-01',NULL);

SELECT
    customer_id,
    from_plan,
    next_plan AS to_plan,
    downgrade_date
FROM (
    SELECT
        customer_id,
        plan_type AS from_plan,
        LEAD(plan_type)  OVER (PARTITION BY customer_id ORDER BY start_date) AS next_plan,
        LEAD(start_date) OVER (PARTITION BY customer_id ORDER BY start_date) AS downgrade_date
    FROM subscriptions
) t
WHERE from_plan IN ('BASIC', 'PRO')
  AND next_plan = 'FREE';
  
  
  
-- Find the number of likes, comments, and shares for each post.
CREATE TABLE posts (
    post_id INT PRIMARY KEY,
    user_id INT,
    post_date DATE
);

CREATE TABLE engagements (
    engagement_id INT PRIMARY KEY,
    post_id INT,
    engagement_type VARCHAR(10)  -- LIKE, COMMENT, SHARE
);

INSERT INTO posts VALUES
(1,101,'2024-06-01'),
(2,102,'2024-06-02'),
(3,101,'2024-06-03');

INSERT INTO engagements VALUES
(1,1,'LIKE'),(2,1,'LIKE'),(3,1,'COMMENT'),(4,1,'SHARE'),
(5,2,'LIKE'),(6,2,'COMMENT'),(7,2,'COMMENT'),
(8,3,'LIKE');

SELECT
    p.post_id,
    SUM(CASE WHEN e.engagement_type = 'LIKE'    THEN 1 ELSE 0 END) AS likes,
    SUM(CASE WHEN e.engagement_type = 'COMMENT' THEN 1 ELSE 0 END) AS comments,
    SUM(CASE WHEN e.engagement_type = 'SHARE'   THEN 1 ELSE 0 END) AS shares
FROM posts p
LEFT JOIN engagements e
    ON p.post_id = e.post_id
GROUP BY p.post_id;
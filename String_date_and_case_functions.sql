-- Checking difference type of manipulate and format text data (String functions)
-- Cleaning up messy inputs, extracting parts of a string or combining multiple columns into one readable output.


SELECT 
    UPPER(employee_name), LOWER(employee_name)
FROM
    employees;

-- LENGTH()
-- Returns the number of characters in a string.
SELECT 
    employee_name, LENGTH(employee_name) AS name_length
FROM
    employees;


-- CONCAT()
-- Joins two or more strings into one.
SELECT 
    CONCAT(employee_name, ' works in ', city) AS summary
FROM
    employees;

-- SUBSTRING()
-- Extracts a protion of a string, given a starting position and length
SELECT 
    SUBSTRING(employee_name, 1, 3) AS first_3_words
FROM
    employees;


-- LEFT() / RIGHT()
-- Grabs a fixed number of characters from the start or end of a string.
SELECT 
    LEFT(employee_name, 3) AS first_3,
    RIGHT(employee_name, 3) AS last_3
FROM
    employees;


-- REPLACE()
-- Finds and replaces all occurances of a substring.
SELECT 
    REPLACE('raj.sharma@oldcompany.com',
        'oldcompany',
        'newcompany');


-- SUBSTRING_INDEX()
-- Extracts a portion of a string before or after a specified occurrence of a delimiter.

SELECT SUBSTRING_INDEX('raj.sharma@company.com', '@', 1);-- 'raj.sharma'
SELECT SUBSTRING_INDEX('raj.sharma@company.com', '@', - 1);-- 'company.com'


SELECT CURDATE();


-- DATEDIFF() -- Returns the difference between two dates in days. 
SELECT 
    DATEDIFF(CURDATE(), hire_date) AS days_employed
FROM
    employees;


-- DATE_FORMAT() -- Formats a date into a custom, human-readable string;
SELECT 
    hire_date,
    DATE_FORMAT(hire_date, '%d-%b-%Y') AS formatted_date
FROM
    employees;


-- YEAR() / MONTH() / MONTHNAME() / DAYNAME()
-- Extract individual parts of a date;
SELECT 
    YEAR(hire_date) AS hire_year,
    MONTH(hire_date) AS hire_month,
    MONTHNAME(hire_date) AS month_name,
    DAYNAME(hire_date) AS day_name
FROM
    employees;


-- TIMESTAMPDIFF()
-- Returns the difference between two dates in a unit you specity
SELECT 
    TIMESTAMPDIFF(YEAR,
        hire_date,
        CURDATE()) AS years_employed,
    TIMESTAMPDIFF(MONTH,
        hire_date,
        CURDATE()) AS months_employed
FROM
    employees;


-- Practice Questions
-- Display employee details in the format: Raj Sharma (raj.sharma@company.com) - Mumbai
SELECT 
    CONCAT(employee_name,
            '(',
            email,
            ')',
            '- ',
            city) AS employee_name_format
FROM
    employees;


-- Extract the username from employee email addresses.
SELECT 
    email, SUBSTRING_INDEX(email, '@', 1) AS user_name
FROM
    employees;


-- Display employee initials. e.g., Raj Sharma → RS, Priya Mehta → PM
SELECT 
    CONCAT(LEFT(TRIM(employee_name), 1),
            LEFT(SUBSTRING_INDEX(TRIM(employee_name), ' ', - 1),
                1)) AS employee_initials
FROM
    employees


-- Find employees whose email domain is gmail.com.
-- Approach 1
select * from employees
where email like '%gmail.com';

-- Approach 2 with Substring_index()
select * from employees
where substring_index(email, '@', -1) = 'gmail.com';


-- Find employees who joined in the last 30 days.
-- Approach 1
select * from employees
where hire_date >= curdate() - interval 30 day;

-- Approach 2
select * from employees
where hire_date >= date_sub(curdate(), interval 30 day);


-- Find employees who have completed more than 5 years in the company.
select * from employees
where timestampdiff(year, hire_date, curdate()) > 5;


-- Display employee name, joining year, joining month name, and total years of experience.
select employee_name,
year(hire_date) as joining_year,
monthname(hire_date) as joining_month_name,
timestampdiff(year, hire_date, curdate()) as employee_experience
from employees;

-- Display bonus details along with the day name on which the bonus was awarded.
select *,
dayname(bonus_date) as bonus_day
from bonuses;


-- Display all projects along with their start date in the format: 01-Jan-2025
select *,
date_format(start_date, '%d-%b-%Y') as start_date_formated
from projects;



-- Categorize employees based on salary.
SELECT 
    employee_name,
    salary,
    CASE
        WHEN salary >= 100000 THEN 'High Salary'
        WHEN salary BETWEEN 60000 AND 99999 THEN 'Medium Salary'
        ELSE 'Low Salary'
    END AS employee_salary_ranking
FROM
    employees;
    
    

-- Categorize employees based on experience.
SELECT
    employee_name,
    TIMESTAMPDIFF(YEAR, hire_date, CURDATE()) AS years_of_experience,
    CASE
        WHEN TIMESTAMPDIFF(YEAR, hire_date, CURDATE()) <= 2 THEN 'Junior'
        WHEN TIMESTAMPDIFF(YEAR, hire_date, CURDATE()) BETWEEN 3 AND 5 THEN 'Mid Level'
        ELSE 'Senior'
    END AS employee_experience_ranking
FROM employees;



-- Find the total number of Active employees using CASE.
-- Approach 1: Simple COUNT with WHERE
SELECT COUNT(*) AS total_employees
FROM employees
WHERE employment_status = 'Active';

-- Approach 2: CASE inside SUM()
SELECT
    SUM(
        CASE
            WHEN employment_status = 'Active' THEN 1
            ELSE 0
        END
    ) AS total_employees
FROM employees;


SELECT
    SUM(CASE WHEN employment_status = 'Active' THEN 1 ELSE 0 END) AS active_count,
    SUM(CASE WHEN employment_status = 'Inactive' THEN 1 ELSE 0 END) AS inactive_count
FROM employees;
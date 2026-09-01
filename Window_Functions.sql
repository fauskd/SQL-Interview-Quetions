-- Assign a unique row number to each employee based on salary
select *,
row_number() over(order by salary desc)
from employees;

-- Rank employees based on salary using RANK()
select *, 
rank() over(order by salary desc) as rank_col
from employees;


-- Rank employees based on salary using DENSE_RANK()
select *,
dense_rank() over(order by salary desc) as d_rank_col
from employees;


-- Compare ROW_NUMBER vs RANK vs DENSE_RANK side by side
select department,
salary,
row_number() over(order by salary desc) as row_num_col,
rank() over(order by salary desc) as rank_col,
dense_rank() over(order by salary desc) as dense_rank_col
from employees;



-- Find the employee with the 2nd highest salary
-- Using limit and offset
select * from employees
order by salary desc
limit 1 offset 1;

-- But if we have two 2nd highest salary in our dataset 
select *
from (select *,
dense_rank() over(order by salary desc) as dense_rank_col
from employees) as t
where dense_rank_col = 2;


-- Display each employee's rank within their department based on salary
select *,
rank() over(partition by department order by salary desc) as department_rank
from employees
where department is not null;


-- Find the highest-paid employee from each department
select *
from (select *, 
rank() over(partition by department order by salary desc) as ranking
from employees) as t
where ranking = 1 and department is not null;


-- Find employees earning more than the previous employee
select *
from (select *,
lag(salary) over(order by employee_id) as previous_salary
from employees) as t
where salary> previous_salary;

-- If you want 2 previous salary 
select *,
lag(salary,2) over(order by employee_id) as previous_salary
from employees;

-- If you want to change the values by 0 if the previous salary is empty
select *,
lag(salary, 2, 0) over(order by employee_id) as previous_salary
from employees;


-- Find employees earning less than the next employee
select *
from (select *,
lead(salary) over(order by employee_id) as next_salary
from employees) as t
where salary<next_salary;

-- Display the salary difference between each employee and the previous employee
select *,
salary-lag(salary) over(order by employee_id) as salary_diff
from employees;

-- LAG vs LEAD — side-by-side comparison

select *,
lag(salary) over() as previous_salary,
lead(salary) over() as next_salary
from employees; 

-- GROUP BY vs PARTITION BY — side-by-side comparison
select department from employees
group by department;

select *, 
rank() over(partition by department order by salary desc) as ranked_col
from employees;


-- Find departments where multiple employees share the same salary rank
with ranked as (select *,
rank() over(partition by department order by salary) as ranked_col
from employees
where department is not null)
select department,ranked_col, count(*)
from ranked
group by department, ranked_col
having count(*) >1;


-- Display each employee along with the total salary expense of their department
select *,
sum(salary) over(partition by department) as total_expenses
from employees
where department is not null;


-- Display a running total of salaries within each department

select *,
sum(salary) over(partition by department order by employee_id) as running_expenses
from employees
where department is not null;

-- Find employees earning more than the average salary of their department
with avg_salary as (select *,
avg(salary) over(partition by department) as avg_salary_per_dept
from employees)
select *
from avg_salary
where salary> avg_salary_per_dept;
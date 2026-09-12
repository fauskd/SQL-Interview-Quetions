-- Using a CTE, find departments having more than 5 employees.
-- normal condition
select department, count(*) as total_employees
from employees
group by department
having count(*) > 5;

-- With CTE
with department_emp as (select department, 
count(*) as total_dept_employees
from employees
group by department)
select * from department_emp
where total_dept_employees > 5;

-- Using Multiple CTEs, find departments whose average salary is greater than the company average salary.

with avg_dept_salary as (select department,
avg(salary) as avg_dept_salary
from employees
group by department),
avg_company_salary as (select avg(salary) as company_avg_salary
from employees)
select d.*, c.*
from avg_dept_salary as d
cross join avg_company_salary as c
where d.avg_dept_salary > c.company_avg_salary;

-- Using a CTE, find employees who have received more than one bonus.
with employee_bonus as (select employee_id, count(*) as total_bonus
from bonuses
group by employee_id)

select e.employee_id, e.employee_name, b.total_bonus
from employees as e
inner join employee_bonus as b
on e.employee_id = b.employee_id
where b.total_bonus > 1;


-- Using a CTE, find the top 2 highest-paid employees from each department.
select * 
from (select *, 
rank() over(partition by department order by salary desc) as highest_salary
from employees
where department is not null)as t
where highest_salary <= 2;


-- Using Multiple CTEs, find employees whose salary is greater than the average salary of their department, 
-- and display their department rank.
with dept_avg as (select *,
avg(salary) over(partition by department) as avg_salary
from employees
where department is not null),

dept_rank as (select *,
rank() over(partition by department order by salary desc) as rank_avg_salay
from dept_avg)

select * 
from dept_rank
where salary > avg_salary;
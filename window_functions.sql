-- Window Functions
-- They perform aggregate operations on groups of rows, but
-- they produce a result for each row.
-- Instead of grouping we get an aggregate function result in another column next to each member
-- of a "group" - windows of data
CREATE DATABASE window_functions;
USE window_functions;

CREATE TABLE employees (
    emp_no INT PRIMARY KEY AUTO_INCREMENT,
    department VARCHAR(20),
    salary INT
);
 
INSERT INTO employees (department, salary) VALUES
('engineering', 80000),
('engineering', 69000),
('engineering', 70000),
('engineering', 103000),
('engineering', 67000),
('engineering', 89000),
('engineering', 91000),
('sales', 59000),
('sales', 70000),
('sales', 159000),
('sales', 72000),
('sales', 60000),
('sales', 61000),
('sales', 61000),
('customer service', 38000),
('customer service', 45000),
('customer service', 61000),
('customer service', 40000),
('customer service', 31000),
('customer service', 56000),
('customer service', 55000);

SELECT * FROM employees;
 
SELECT department, AVG(salary) FROM employees
GROUP BY department;

-- OVER
-- The OVER() clause constructs a window. When it's empty, the window will include all records
SELECT AVG(salary) OVER() FROM employees; -- window that inculudes all the records
-- gives average salary alongside each row
SELECT emp_no, department, salary, AVG(salary) OVER() AS avg_salary FROM employees;
-- it is one big group

SELECT emp_no, department, salary,
		MIN(salary) OVER() AS MIN,
        MAX(salary) OVER() AS MAX
FROM employees;

-- PARTITION BY
-- Use PARTITION BY inside of the OVER() to form rows into groups of rows
SELECT emp_no, department, salary,
	ROUND(AVG(salary) OVER(PARTITION BY department), 2) AS avg_department,
    ROUND(AVG(salary) OVER(), 2) AS avg_company
FROM employees;

SELECT emp_no, department, salary, COUNT(*) OVER(PARTITION BY department) AS department_count
FROM employees;

SELECT emp_no, department, salary, SUM(salary) OVER(PARTITION BY department) AS department_payroll,
	SUM(salary) OVER() AS company_payroll
FROM employees;

-- ORDER BY
-- Use ORDER BY inside of the OVER() clause to re-order rows within each window
SELECT emp_no, department, salary,
	SUM(salary) OVER(PARTITION BY department ORDER BY salary) AS rolling_dep_salary,
    SUM(salary) OVER(PARTITION BY department) AS total_dep_salary
FROM employees;
-- it is a rolling sum, in each row the rolling sum is the sum of only current and previous values
SELECT emp_no, department, salary,
	MIN(salary) OVER(PARTITION BY department ORDER BY salary DESC) AS rolling_min
FROM employees;

-- Functions below can be only used with window functions
-- RANK()
-- same values = the same rank
-- by default, the lowest value = rank 1
-- does not require PARTITION BY
-- skips ranks if there are duplicated values
SELECT emp_no, department, salary, 
	RANK() OVER(ORDER BY salary DESC) AS overall_salary
FROM employees;

SELECT emp_no, department, salary,
	RANK() OVER(PARTITION BY department ORDER BY salary DESC) AS dept_salary_rank,
    RANK() OVER(ORDER BY salary DESC) AS overall_salary_rank
FROM employees ORDER BY department;

-- ROW_NUMBER()
-- just counts the rows
-- DENSE_RANK()
-- works as RANK() but does not skip any ranks if there are duplicated values
SELECT emp_no, department, salary,
	ROW_NUMBER() OVER(PARTITION BY department ORDER BY salary DESC) AS dept_row_number,
	RANK() OVER(PARTITION BY department ORDER BY salary DESC) AS dept_salary_rank,
    RANK() OVER(ORDER BY salary DESC) AS overall_salary_rank,
    DENSE_RANK() OVER(ORDER BY salary DESC) AS overall_dense_rank
FROM employees ORDER BY overall_salary_rank;

-- NTILE(N) 
-- We provide value N and our windows will be divided into N buckets
-- here we check to what quartile a current salary belongs
SELECT emp_no, department, salary,
	NTILE(2) OVER(PARTITION BY department) AS dep_quartile,
	NTILE(4) OVER(ORDER BY salary DESC) AS salary_quartile
FROM employees
ORDER BY department;

-- FIRST_VALUE(expr)
-- returns the value of expr from the first row of the window frame
SELECT
	emp_no,
    department,
    salary,
    FIRST_VALUE(emp_no) OVER (ORDER BY salary DESC) AS highest_overall, -- 10 has the highest salary 
    FIRST_VALUE(emp_no) OVER(PARTITION BY department ORDER BY salary DESC) AS highest_dep
FROM employees;

-- LAST_VALUE(expr)
-- NTH_VALUE(expr, N) 
-- the functions in quetion work same as FIRST_VALUE

-- LAG() and LEAD()
-- LAG() returns value from the previous row
-- LEAD() returns value from the next row
-- we can calculate differenece
SELECT emp_no, department, salary,
	salary - LAG(salary) OVER(ORDER BY salary DESC) AS salary_diff
FROM employees;

SELECT emp_no, department, salary,
	salary - LEAD(salary) OVER(ORDER BY salary DESC) AS salary_diff
FROM employees;

SELECT emp_no,
	department,
    salary,
    salary - LAG(salary) OVER(PARTITION BY department ORDER BY salary DESC) AS dep_salary_diff
FROM employees;
USE employees;

-- Basic aggregation
SELECT department_id, COUNT(*) AS num_employees FROM employees GROUP BY department_id;
SELECT job_id, AVG(salary) AS avg_salary, MIN(salary) AS min_salary, MAX(salary) AS max_salary FROM employees GROUP BY job_id;
SELECT COUNT(DISTINCT department_id) AS distinct_departments FROM employees;

-- GROUPING SETS / ROLLUP / CUBE
SELECT department_id, job_id, SUM(salary) AS total_salary
FROM employees
GROUP BY GROUPING SETS ((department_id, job_id), (department_id), (job_id), ());

SELECT department_id, SUM(salary) AS total_salary
FROM employees
GROUP BY ROLLUP(department_id);

SELECT job_id, department_id, SUM(salary) AS total_salary
FROM employees
GROUP BY CUBE(job_id, department_id);

-- HAVING filter after aggregation
SELECT department_id, COUNT(*) AS cnt
FROM employees
GROUP BY department_id
HAVING COUNT(*) > 2;

-- Analytic / window functions
SELECT employee_id,
       first_name,
       last_name,
       department_id,
       salary,
       AVG(salary) OVER (PARTITION BY department_id) AS avg_dept_salary,
       RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS dept_salary_rank,
       ROW_NUMBER() OVER (ORDER BY hire_date) AS overall_hire_order
FROM employees;

-- Running total of salary by hire_date
SELECT employee_id,
       hire_date,
       salary,
       SUM(salary) OVER (ORDER BY hire_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total_salary
FROM employees;

-- Percentile and distribution
SELECT employee_id,
       salary,
       PERCENT_RANK() OVER (ORDER BY salary) AS pct_rank,
       CUME_DIST() OVER (ORDER BY salary) AS cum_dist
FROM employees;

-- Hierarchical query (manager -> subordinates)
SELECT employee_id,
       first_name || ' ' || last_name AS full_name,
       manager_id,
       LEVEL AS hierarchy_level
FROM employees
START WITH manager_id IS NULL
CONNECT BY PRIOR employee_id = manager_id;

-- Normalization check: inconsistent totals between history and current
SELECT e.employee_id,
       e.department_id AS current_dept,
       jh.department_id AS historical_dept,
       jh.start_date,
       jh.end_date
FROM employees e
JOIN job_history jh ON e.employee_id = jh.employee_id
WHERE e.department_id <> jh.department_id;

-- Use NVL / COALESCE / DECODE for null handling and conditional mapping
SELECT employee_id,
       NVL(manager_id, 0) AS mgr_id_or_zero,
       COALESCE(last_name, 'UNKNOWN') AS last_name_safe,
       DECODE(job_id, 'DEV', 'Developer', 'HRM', 'HR Manager', 'OTHER') AS job_label
FROM employees;

-- Rollup example with label for totals
SELECT department_id,
       COUNT(*) AS headcount,
       SUM(salary) AS total_salary
FROM employees
GROUP BY ROLLUP(department_id);

-- Pivot-like summary using conditional aggregation
SELECT department_id,
       SUM(CASE WHEN salary >= 80000 THEN 1 ELSE 0 END) AS high_earners,
       SUM(CASE WHEN salary < 80000 THEN 1 ELSE 0 END) AS others
FROM employees
GROUP BY department_id;

-- File: 04_views_indexes.sql

CREATE OR REPLACE VIEW employee_full_info AS
SELECT e.employee_id,
       e.first_name,
       e.last_name,
       e.email,
       e.phone_number,
       e.hire_date,
       j.job_title,
       e.salary,
       d.department_name,
       m.first_name || ' ' || m.last_name AS manager_name
FROM employees e
LEFT JOIN jobs j ON e.job_id = j.job_id
LEFT JOIN departments d ON e.department_id = d.department_id
LEFT JOIN employees m ON e.manager_id = m.employee_id;

CREATE OR REPLACE VIEW department_headcount AS
SELECT d.department_id,
       d.department_name,
       COUNT(e.employee_id) AS employee_count
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name;

CREATE OR REPLACE VIEW job_history_summary AS
SELECT employee_id,
       job_id,
       department_id,
       start_date,
       end_date,
       MONTHS_BETWEEN(end_date, start_date) AS months_in_role
FROM job_history;

CREATE MATERIALIZED VIEW mv_department_headcount
BUILD IMMEDIATE
REFRESH FAST ON COMMIT
AS
SELECT d.department_id,
       d.department_name,
       COUNT(e.employee_id) AS employee_count
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name;

CREATE INDEX idx_emp_department ON employees(department_id);
CREATE INDEX idx_emp_job ON employees(job_id);
CREATE INDEX idx_emp_manager ON employees(manager_id);
CREATE INDEX idx_jobs_title ON jobs(job_title);
CREATE INDEX idx_dept_name ON departments(department_name);
CREATE INDEX idx_loc_city ON locations(city);
CREATE UNIQUE INDEX ux_employee_email ON employees(email);
CREATE INDEX idx_emp_name_composite ON employees(last_name, first_name);
CREATE INDEX idx_lower_email ON employees(LOWER(email));

BEGIN
  EXECUTE IMMEDIATE 'ALTER MATERIALIZED VIEW mv_department_headcount COMPILE';
END;
/

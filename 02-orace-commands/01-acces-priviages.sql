CREATE USER emp_user IDENTIFIED BY emp_password;
CREATE USER emp_manager IDENTIFIED BY mgr_password;
CREATE USER emp_admin IDENTIFIED BY admin_password;

GRANT CONNECT TO emp_user;
GRANT CONNECT, RESOURCE TO emp_manager;
GRANT CONNECT, RESOURCE, DBA TO emp_admin;

GRANT SELECT, INSERT, UPDATE ON employees TO emp_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON employees TO emp_manager;
GRANT ALL PRIVILEGES ON employees TO emp_admin;

GRANT SELECT, INSERT, UPDATE ON departments TO emp_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON departments TO emp_manager;
GRANT ALL PRIVILEGES ON departments TO emp_admin;

GRANT SELECT, INSERT, UPDATE ON jobs TO emp_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON jobs TO emp_manager;
GRANT ALL PRIVILEGES ON jobs TO emp_admin;

GRANT SELECT, INSERT, UPDATE ON job_history TO emp_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON job_history TO emp_manager;
GRANT ALL PRIVILEGES ON job_history TO emp_admin;

GRANT SELECT, INSERT, UPDATE ON locations TO emp_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON locations TO emp_manager;
GRANT ALL PRIVILEGES ON locations TO emp_admin;

REVOKE DELETE ON employees FROM emp_user;
REVOKE DELETE ON departments FROM emp_user;
REVOKE DELETE ON jobs FROM emp_user;
REVOKE DELETE ON job_history FROM emp_user;
REVOKE DELETE ON locations FROM emp_user;

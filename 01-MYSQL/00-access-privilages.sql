-- Setup roles, users, privileges for ecommerce_data; includes creation, grants, and example revokes/adjustments

CREATE DATABASE IF NOT EXISTS eccommerse_data;
USE eccommerse_data;

DROP USER IF EXISTS 'app_user'@'localhost';
DROP USER IF EXISTS 'report_user'@'localhost';
DROP USER IF EXISTS 'admin_user'@'localhost';
DROP ROLE IF EXISTS sales_role;
DROP ROLE IF EXISTS readonly_role;
DROP ROLE IF EXISTS limited_read;

CREATE ROLE IF NOT EXISTS sales_role;
CREATE ROLE IF NOT EXISTS readonly_role;

GRANT SELECT, INSERT, UPDATE ON eccommerse_data.orders TO sales_role;
GRANT SELECT, INSERT ON eccommerse_data.order_items TO sales_role;

GRANT SELECT ON eccommerse_data.users TO readonly_role;
GRANT SELECT ON eccommerse_data.products TO readonly_role;
GRANT SELECT ON eccommerse_data.orders TO readonly_role;
GRANT SELECT ON eccommerse_data.order_items TO readonly_role;
GRANT SELECT ON eccommerse_data.reviews TO readonly_role;

CREATE USER 'app_user'@'localhost' IDENTIFIED BY 'AppPass123!';
GRANT sales_role TO 'app_user'@'localhost';
SET DEFAULT ROLE sales_role FOR 'app_user'@'localhost';

CREATE USER 'report_user'@'localhost' IDENTIFIED BY 'ReportPass456!';
GRANT readonly_role TO 'report_user'@'localhost';
SET DEFAULT ROLE readonly_role FOR 'report_user'@'localhost';

CREATE USER 'admin_user'@'localhost' IDENTIFIED BY 'AdminPass789!';
GRANT ALL PRIVILEGES ON *.* TO 'admin_user'@'localhost' WITH GRANT OPTION;

-- Example revocations and adjustments
REVOKE sales_role FROM 'app_user'@'localhost';
REVOKE readonly_role FROM 'report_user'@'localhost';

REVOKE UPDATE ON eccommerse_data.orders FROM sales_role;
REVOKE SELECT ON eccommerse_data.reviews FROM readonly_role;

DROP ROLE IF EXISTS readonly_role;

CREATE ROLE IF NOT EXISTS limited_read;
GRANT SELECT ON eccommerse_data.users TO limited_read;
GRANT SELECT ON eccommerse_data.products TO limited_read;

GRANT limited_read TO 'report_user'@'localhost';
SET DEFAULT ROLE limited_read FOR 'report_user'@'localhost';

REVOKE ALL PRIVILEGES, GRANTS FROM 'admin_user'@'localhost';

FLUSH PRIVILEGES;

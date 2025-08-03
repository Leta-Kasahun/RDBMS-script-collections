-- ===================================
-- Backup and Recovery Basics for MySQL
-- ===================================

-- 1. Backup using mysqldump (run in your OS shell, not inside MySQL):
-- Backup entire database
-- mysqldump -u username -p eccommerse_data > eccommerse_data_backup.sql

-- Backup specific tables
-- mysqldump -u username -p eccommerse_data users products orders > partial_backup.sql

-- 2. Restore database from backup file (run in OS shell):
-- mysql -u username -p eccommerse_data < eccommerse_data_backup.sql

-- 3. Logical Backup from inside MySQL (limited, for quick export)
-- Export to CSV example for users table:
SELECT * INTO OUTFILE '/tmp/users_backup.csv'
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
FROM users;

-- 4. Recovery of data from CSV
-- (Make sure file is accessible by MySQL server)
LOAD DATA INFILE '/tmp/users_backup.csv'
INTO TABLE users
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

-- 5. Backup with Percona XtraBackup or MySQL Enterprise Backup (advanced, outside scope here)
-- For large/production environments.

-- 6. Point-in-time recovery using binary logs (advanced)
-- Enable binary logging in my.cnf:
-- log-bin=mysql-bin

-- To recover:
-- Use mysqlbinlog tool to replay changes from binary logs.

-- 7. Simple manual backup with transaction consistency (run inside MySQL client)
-- Lock tables, backup with SELECTs, then unlock
FLUSH TABLES WITH READ LOCK;

-- In another session, export data using mysqldump or SELECT INTO OUTFILE

UNLOCK TABLES;

-- 8. Automating backups with scripts & cron jobs
-- Example bash script:
-- #!/bin/bash
-- mysqldump -u username -p'password' eccommerse_data > /backup/$(date +%F)_backup.sql

-- Set it to run daily in cron:
-- 0 2 * * * /path/to/backup_script.sh


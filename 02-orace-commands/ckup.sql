-- File: 07_backup_and_recovery.sql
-- Purpose: Oracle backup and recovery commands and examples

-- Enable flashback (requires FLASHBACK ON and sufficient undo retention)
ALTER DATABASE FLASHBACK ON;
ALTER SYSTEM SET UNDO_RETENTION=7200 SCOPE=BOTH;

-- Flashback query example: view employee state 1 day ago
SELECT * FROM employees AS OF TIMESTAMP (SYSTIMESTAMP - INTERVAL '1' DAY) WHERE employee_id = 1;

-- Data Pump export full schema
-- run from OS shell:
-- expdp employees/emp_password DIRECTORY=dp_dir DUMPFILE=employees_full.dmp LOGFILE=exp_full.log SCHEMAS=employees

-- Data Pump import full schema
-- run from OS shell:
-- impdp employees/emp_password DIRECTORY=dp_dir DUMPFILE=employees_full.dmp LOGFILE=imp_full.log REMAP_SCHEMA=employees:employees

-- Export specific tables
-- expdp employees/emp_password DIRECTORY=dp_dir DUMPFILE=emp_tables.dmp LOGFILE=exp_tables.log TABLES=employees,jobs,departments

-- Import specific tables
-- impdp employees/emp_password DIRECTORY=dp_dir DUMPFILE=emp_tables.dmp LOGFILE=imp_tables.log TABLES=employees,jobs,departments

-- Create consistent backup via RMAN (run in RMAN prompt)
-- Connect: rman target /
BACKUP DATABASE PLUS ARCHIVELOG;
BACKUP AS COMPRESSED BACKUPSET DATABASE;
BACKUP ARCHIVELOG ALL DELETE INPUT;

-- Configure RMAN retention and control file autobackup
CONFIGURE RETENTION POLICY TO REDUNDANCY 2;
CONFIGURE CONTROLFILE AUTOBACKUP ON;

-- Restore and recovery example (RMAN)
-- In RMAN prompt:
-- SHUTDOWN IMMEDIATE;
-- STARTUP MOUNT;
-- RESTORE DATABASE;
-- RECOVER DATABASE;
-- ALTER DATABASE OPEN;

-- Point-in-time recovery using flashback database (if enabled)
-- In SQL*Plus:
-- SELECT FLASHBACK_ON FROM V$DATABASE;
-- FLASHBACK DATABASE TO TIMESTAMP (SYSTIMESTAMP - INTERVAL '2' HOUR);
-- ALTER DATABASE OPEN RESETLOGS;

-- Create export of table to flat file (external table style)
-- spool to file (from SQL*Plus)
SPOOL employees_backup.csv
SET COLSEP ','
SET PAGESIZE 0
SET TRIMSPOOL ON
SELECT employee_id, first_name, last_name, email, salary FROM employees;
SPOOL OFF

-- Load from external CSV would be via SQL*Loader control file (example separate control file needed)

-- Backup control file and spfile
ALTER DATABASE BACKUP CONTROLFILE TO TRACE;
CREATE PFILE='/tmp/init_employees.ora' FROM SPFILE;

-- Recovery catalog registration (example, run in RMAN)
-- RMAN> CONNECT CATALOG rman/rman_pwd@catdb
-- RMAN> REGISTER DATABASE;

-- Validate backups
-- RMAN> VALIDATE BACKUPSET <backupset_number>;
-- RMAN> RESTORE PREVIEW;

-- Checkpoint and log switch for consistent backup
ALTER SYSTEM SWITCH LOGFILE;
ALTER SYSTEM CHECKPOINT;


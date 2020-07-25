
spool  ICODBUPDATE_.log
SET SQLBLANKLINES ON;
SET DEFINE OFF;
SET SQLPREFIX OFF;

prompt ****************Applying MEA/SPR_WAREHOUSE_UPDATER.sql start************************
@MEA/SPR_WAREHOUSE_UPDATER.sql
prompt ****************Applying MEA/SPR_WAREHOUSE_UPDATER.sql end************************
prompt ****************Applying MEA/WAREHOUSE_UPDATE_JOB.sql start************************
@MEA/WAREHOUSE_UPDATE_JOB.sql
prompt ****************Applying MEA/WAREHOUSE_UPDATE_JOB.sql end************************
EXEC DBMS_UTILITY.compile_schema(schema => 'TEST');
Prompt Invalid database objects
set lines 300;
column object_name format a30;
select object_name, object_type from user_objects where status='INVALID';
SET SQLBLANKLINES OFF;
spool off;
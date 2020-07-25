
spool  ICODBUPDATE_.log
SET SQLBLANKLINES ON;
SET DEFINE OFF;
SET SQLPREFIX OFF;

prompt ****************Applying sql/spr_warehouse_updater.sql start************************
@sql/spr_warehouse_updater.sql
prompt ****************Applying sql/spr_warehouse_updater.sql end************************
prompt ****************Applying sql/warehouse_update_job.sql start************************
@sql/warehouse_update_job.sql
prompt ****************Applying sql/warehouse_update_job.sql end************************
EXEC DBMS_UTILITY.compile_schema(schema => 'TEST');
Prompt Invalid database objects
set lines 300;
column object_name format a30;
select object_name, object_type from user_objects where status='INVALID';
SET SQLBLANKLINES OFF;
spool off;
begin
  sys.dbms_scheduler.create_job ( job_name => 'warehouse_update_job', job_type => 'plsql_block', job_action => 'declare
pio_err varchar2(200);
begin
pio_err := ''ok'';
ico_mea_stg.spr_warehouse_updater( pio_err => pio_err );
end
;
', number_of_arguments => 0, start_date => systimestamp, repeat_interval => 'freq=daily; byhour=6; byminute=0; bysecond=0;',
enabled => true, auto_drop => true, comments => 'data warehouse update job', credential_name => null, destination_name => null);
end ;
/
commit;
exec dbms_scheduler.enable('warehouse_update_job');
commit;
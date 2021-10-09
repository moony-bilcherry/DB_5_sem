drop tablespace ynk_qdata including contents and datafiles;
alter pluggable database ynk_pdb close;

-- 1: списки всех файлов табличных пространств
select tablespace_name, file_name from dba_data_files; 
select tablespace_name, file_name from dba_temp_files;
    
-- 2
create tablespace ynk_qdata 
    datafile 'ynk_qdata.dbf'
    size 10 m
offline;

alter tablespace ynk_qdata online;
alter user ynkcore quota 2m on ynk_qdata;
alter user ynkcore identified by 11111;

-- соединение ynkcore к orcl

create table YNK_T1(
    x number(20) primary key,
    y number(20))
tablespace ynk_qdata;

insert into YNK_T1 values (1, 101);
insert into YNK_T1 values (2, 102);
insert into YNK_T1 values (3, 103);

select * from YNK_T1;

-- 3
select * from dba_segments where tablespace_name = 'YNK_QDATA';
select * from dba_segments;

-- 4 
drop table YNK_T1;
-- изменилось им€ сегмента, информаци€ об удалении занесена в корзину
select * from user_recyclebin;
-- удаление объекта из корзины, сегмент удал€етс€ и восстановление невозможно
purge table YNK_T1;

-- 5: flashback восстановит таблицу, если корзина не очищена
-- восстановитс€ им€ сегмента, но не индекса
flashback table YNK_T1 to before drop;

-- 6:
begin
  for x in 4..10004
  loop
    insert into YNK_T1 values(x, x);
  end loop;
end;
commit;

select count(*) from YNK_T1;

-- 7 
select segment_name, segment_type, 
    tablespace_name, bytes, blocks, extents
from user_segments where tablespace_name = 'YNK_QDATA';

select * from user_extents 
where tablespace_name = 'YNK_QDATA';

-- 8
drop tablespace ynk_qdata including contents and datafiles;

-- 9: все группы журналов, текуща€ - current
select * from v$log;

-- 10: файлы всех журналов
select * from v$logfile;

-- 11: пройти круг по логфайлам (после изменени€ current мен€етс€ на следующий
-- в цикле 1 -> 2 -> 3 -> 1)
alter system switch logfile;
select * from v$log;

-- 12: добавить группу и 3 логфайла в нее
alter database add logfile group 4 'C:\app\oracle_user\oradata\orcl\REDO04.LOG'
    size 50m blocksize 512;
alter database add logfile member 
    'C:\app\oracle_user\oradata\orcl\REDO041.LOG'  to group 4;
alter database add logfile member 
    'C:\app\oracle_user\oradata\orcl\REDO042.LOG'  to group 4;

select * from v$log;
select * from v$logfile;

-- 13: удалить созданный лог и логфайлы
alter database drop logfile member 'C:\app\oracle_user\oradata\orcl\REDO042.LOG';
alter database drop logfile member 'C:\app\oracle_user\oradata\orcl\REDO041.LOG';
alter database drop logfile group 4;

select * from v$log;
select * from v$logfile;

-- 14
select name, log_mode from v$database;
select instance_name, archiver, active_state from v$instance;

-- 15
select * from v$log;
select * from v$archived_log;

-- 16 включить архивирование через sqlplus на сервере
-- connect / as sysdba;
-- shutdown immediate;
-- startup mount;
-- alter database archivelog;
-- alter database open;
select name, log_mode from v$database;
select instance_name, archiver, active_state from v$instance;

-- 17: принудительно создать архивный файл
alter system switch logfile;
select * from v$archived_log;

-- 18: отключить архивирование (sqlplus)
-- startup mount;
-- alter database noarchivelog;
select name, log_mode from v$database;
select instance_name, archiver, active_state from v$instance;

-- 19: список управл€ющих файлов
select * from v$controlfile;

-- 20:
show parameter control;
select * from v$controlfile_record_section;

-- 21: расположение файла параментров:
-- C:\app\oracle_user\product\12.1.0\dbhome_1\database

-- 22: 
create pfile = 'ynk_pfile.ora' from spfile;
-- расположение: C:\app\oracle_user\product\12.1.0\dbhome_1\database\ynk_pfile.ora

-- 23: расположение файла паролей инстанса:
-- C:\app\oracle_user\product\12.1.0\dbhome_1\database\PWDorcl.ora
select * from v$pwfile_users;
show parameter remote_login_passwordfile;

-- 24: перечень директориев дл€ файлов сообщений и диагностики
select * from v$diag_info;

-- 25: посмотреть в log.xml
-- C:\app\oracle_user\diag\rdbms\orcl\orcl\alert\log.xml
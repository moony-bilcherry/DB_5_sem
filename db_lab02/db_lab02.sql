-- 1
create tablespace ts_ynk 
    datafile 'ts_ynk.dbf'
    size 7 m
    autoextend on next 5 m
    maxsize 20 m
    extent management local;

-- 2
create temporary tablespace ts_ynk_temp
    tempfile 'ts_ynk_temp.dbf'
    size 5 m
    autoextend on next 3 m
    maxsize 30 m
    extent management local;

-- 3
select tablespace_name, status, 
    contents logging 
    from sys.dba_tablespaces;

select file_name, tablespace_name, 
    status, maxbytes, user_bytes
    from dba_data_files
union
select file_name, tablespace_name, 
    status, maxbytes, user_bytes
    from dba_temp_files;

-- 4
-- чинит ошибку ORA-65096 при создании юзеров/ролей/др. с нестандартными именами
alter session set "_ORACLE_SCRIPT"=true;

create role rl_ynkcore;
grant connect,
    create table,
    drop any table,
    create view,
    drop any view,
    create procedure, 
    drop any procedure
    to rl_ynkcore;
commit;

--5
select * from sys.dba_roles;
select * from sys.dba_roles where role like '%YNK%';
select * from dba_sys_privs where grantee like '%YNK%';

--6
create profile pf_ynkcore limit
    password_life_time 180
    sessions_per_user 3
    failed_login_attempts 7
    password_lock_time 1
    password_reuse_time 10
    password_grace_time default 
    connect_time 180
    idle_time 30;
commit;

--7
select * from dba_profiles where profile like '%YNK%';
select * from dba_profiles where profile = 'DEFAULT';

--8
create user ynkcore 
    identified by qqqq
    default tablespace ts_ynk quota unlimited on ts_ynk
    temporary tablespace ts_ynk_temp
    profile pf_ynkcore
    account unlock
    password expire;
grant rl_ynkcore to ynkcore;

--9: через sqlplus поменяла просроченный пароль на ynk

--10: создала соединение для ynkcore
create table ynkcore_table (i int, j int);

insert into ynkcore_table (i, j) values (1, 111);
insert into ynkcore_table (i, j) values (2, 222);
select * from ynkcore_table;

create view ynkcore_view as select * from ynkcore_table;
select * from ynkcore_view;
commit;

--11:
create tablespace ynk_qdata
    datafile 'ynk_qdata.dbf'
    size 10m
    autoextend on next 5m
    maxsize 30m
    offline;
alter tablespace ynk_qdata online;

alter user ynkcore quota 2m on ynk_qdata;

create table ynk_t1 (str varchar(50)) tablespace ynk_qdata;
insert into  ynk_t1 values ('1');
insert into  ynk_t1 values ('2');
insert into  ynk_t1 values ('3');
select * from  ynk_t1;

commit;
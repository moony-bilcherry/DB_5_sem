--1
select * from v$pdbs;

--2
select * from v$instance;

--3
select * from product_component_version;

--4: создана YNK_PDB
alter pluggable database ynk_pdb open;

--5
select * from v$pdbs;

--6: создаем табличное пространство роль, профиль безопасности, глобального пользователя
-- соединение sys к ynk_pdb
create tablespace ts_ynk_pdb 
    datafile 'ts_ynk_pdb.dbf'
    size 7 m
    autoextend on next 5 m
    maxsize 20 m
    extent management local;
    
create temporary tablespace ts_ynk_pdb_temp
    tempfile 'ts_ynk_pdb_temp.dbf'
    size 5 m
    autoextend on next 3 m
    maxsize 30 m
    extent management local;
    
select tablespace_name, status, 
    contents logging 
    from sys.dba_tablespaces;
    
alter session set "_ORACLE_SCRIPT"=true;

alter session set container=ynk_pdb;

create role rl_ynk_pdb;
grant connect,
    create table,
    drop any table,
    create view,
    drop any view,
    create procedure, 
    drop any procedure
    to rl_ynk_pdb;
commit;

create profile pf_ynk_pdb limit
    password_life_time 180
    sessions_per_user 3
    failed_login_attempts 7
    password_lock_time 1
    password_reuse_time 10
    password_grace_time default 
    connect_time 180
    idle_time 30;
commit;

create user user_ynk_pdb 
    identified by 12345
    default tablespace ts_ynk_pdb quota unlimited on ts_ynk_pdb
    temporary tablespace ts_ynk_pdb_temp
    profile pf_ynk_pdb
    account unlock;
grant rl_ynk_pdb to user_ynk_pdb;

-- 7
-- переключила соединение на user_ynk_pdb к ynk_pdb
create table ynk_pdb_table (i int, j int);

insert into ynk_pdb_table (i, j) values (1, 111);
insert into ynk_pdb_table (i, j) values (2, 222);
select * from ynk_pdb_table;
drop table ynk_pdb_table;

-- 8: соединение sys к ynk_pdb
select * from dba_tablespaces;
select * from dba_data_files;
select * from dba_temp_files;
select * from dba_roles;
select grantee, privilege from dba_sys_privs;
select * from dba_profiles;
select * from all_users;

-- 9: соединение sys к orcl
create user c##ynk identified by 11111;
grant create session to c##ynk;
-- sys к ynk_pdb
grant create session to c##ynk;
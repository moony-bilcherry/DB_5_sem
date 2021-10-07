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
-- изменилось имя сегмента, информация об удалении занесена в корзину
select * from user_recyclebin;
-- удаление объекта из корзины, сегмент удаляется и восстановление невозможно
purge table YNK_T1;

-- 5: flashback восстановит таблицу, если корзина не очищена
-- восстановится имя сегмента, но не индекса
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

create table YNK_t(
    x number(3) primary key, 
    s varchar2(50));

-- 11
INSERT INTO ynk_t VALUES (102, 'woof');
INSERT INTO ynk_t VALUES (482, 'meow');
INSERT INTO ynk_t VALUES (234, 'aaaa');
INSERT INTO ynk_t VALUES (153, 'uyjthrg');
INSERT INTO ynk_t VALUES (532, 'arelretk');
INSERT INTO ynk_t VALUES (75, 'kujythrgrb');
select * from ynk_t;
commit;

-- 12
update ynk_t set x = x + 20 where x < 300;
select * from ynk_t;
commit;

-- 13
select * from ynk_t where x > 200;
select * from ynk_t where x in(102,423,731);
select sum(x) from ynk_t;

-- 14
delete from ynk_t where x = 482;
select * from ynk_t;
commit;

-- 15
create table ynk_t1(
    x1 number(3),
    t1 varchar2(50),
    constraint ynk_txkey foreign key (x1) references ynk_t(x));
insert into ynk_t1 values (122, 'woofwoof');
insert into ynk_t1 values (254, 'aaaaaaaa!!!!!');
select * from ynk_t1;
commit;

-- 16
select * from ynk_t inner join ynk_t1 on ynk_t.x = ynk_t1.x1;
select * from ynk_t left outer join ynk_t1 on ynk_t.x = ynk_t1.x1;
select * from ynk_t right outer join ynk_t1 on ynk_t.x = ynk_t1.x1;
select * from ynk_t full outer join ynk_t1 on ynk_t.x = ynk_t1.x1;
select * from ynk_t cross join ynk_t1;

-- 17
drop table ynk_t;
drop table ynk_t1;
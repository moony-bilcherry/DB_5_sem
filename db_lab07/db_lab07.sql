-- 1: полный список фоновых процессов
select count(*) from v$bgprocess;
select * from v$bgprocess;

-- 2: фоновые процессы, которые запущены и работают в насто€щий момент
select sid, process, description, program 
    from v$session s join v$bgprocess using (paddr) 
    where s.status = 'ACTIVE';

-- 3: сколько процессов DBWn работает в насто€щий момент
show parameter db_writer_processes;
select count(*) 
    from v$session s join v$bgprocess using (paddr) 
    where s.status = 'ACTIVE' and description like '%writer%';

-- 4: перечень текущих соединений с инстансом
select username, sid, serial#, paddr, status from v$session where username is not null;

-- 5: их режимы
select username, server from v$session where username is not null;

-- 6: определить сервисы (точки подключени€ экземпл€ра)
select name, network_name, pdb from v$services;

-- 7: получить известные вам параметры диспетчера и их значений
show parameter dispatcher;

-- 8: указать в списке Windows-сервисов сервис, реализующий процесс LISTENER
-- cmd services.msc -> *TNSListener

-- 9: перечень текущих соединений с инстансом. (dedicated, shared)
select process from v$session where username is not null;
select * from v$process;

-- 10: содержимое файла LISTENER.ORA
-- C:\app\oracle_user\product\12.1.0\dbhome_1\NETWORK\ADMIN

-- 11: запустить утилиту lsnrctl и по€сните ее основные команды
-- lsnrctl:
    -- start
    -- stop
    -- status
    -- services
    -- trace
    -- version
    -- reload
    -- quit/exit
    -- save_config
    -- ...

-- 12: список служб инстанса, обслуживаемых процессом LISTENER
-- lsnrctl -> services
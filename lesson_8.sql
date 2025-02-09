--Виды языков при работе с БД
--DDL - CREATE, DROP, ALTER - Data definition language - Создает, изменение, удаление объектов бд
--DML - INSERT, UPDATE, DELETE - Data manupulation language - Изменение данных (внутри таблиц)
--SQL - SELECT - structured query language - Язык запросов select
--DCL - GRANT, REVOKE - data control language - Язык доступа к данным

--Создадим запись в таблице в которой цена отрицательная
-- insert into product (code, name, price, producer_id) 
-- values (1008, 'Мясо', -1, 1);

--Создадим запись в таблице в которой цена не указана
-- insert into product (code, name, price, producer_id) 
-- values (1008, 'Мясо', null, 1);
--Для того, чтобы не было возможности вставлять продукты без цены, сделаем свойство колонки not null
alter table product alter column price set not null;

--Создадим запись в таблице в которой цена отрицательная
-- insert into product (code, name, price, producer_id) 
-- values (1008, 'Мясо', -1, 1);
--Для того, чтобы не было возможности вставлять продукты с отрицательной ценой, сделаем ограничение (constraint)
--Ограничение (constraint) - объект в базе данных следящий за выполнением условия при вставке, обновлении таблицы
alter table product add constraint price_is_greater_zero check(price > 0);

--Создаем таблицу, в которой будут студенты с уникальными именами
create table student (id serial primary key, name varchar(50) UNIQUE, lastname varchar(50));
insert into student (name, lastname) values('ivan', 'ivanov');
--Данная запись не вставится
--insert into student (name, lastname) values('petr', 'ivanov');

--Удаление ограничения у таблицы (уникальность имен)
alter table student drop constraint student_name_key;
--Создание ограничение на уникальное сочетание имени и фамилиии
alter table student add constraint unique_name_lastname unique (name, lastname);

--Максимальное значение сиквенса
select setval('student_id_seq' , 2147483647);
--Выдаст ошибку код ниже
--select nextval('student_id_seq');
--КОНЕЦ 1 ЧАСТИ
--2 ЧАСТЬ
--Создание пользователя с паролем
create user jenya with password '1234';
--Создание админа
create user admin_2 with superuser password 'my_admin';

--Переключение между ролями
set role postgres;
set role jenya;
--Просмотр текущего пользователя
SELECT current_user;

--Выдача прав (для этого текущий пользователь должен иметь права на выдачу прав)
--Дает возможность видеть объекты схемы
grant usage on schema public to jenya;
--Дает возможность делать селекты к таблице
grant select on table student to jenya;
--Дает возможность делать все действия внутри таблицы
grant all on table student to jenya;
--Дает возможность создавать объекты в схеме
grant create on schema public to jenya;

--Удаление прав
revoke create on schema public from jenya;
revoke all on table student from jenya;

--Рассмотрим пример, при котором у нас есть таблица с банковскими счетами
create table account (id serial primary key, number varchar(50) NOT NULL UNIQUE, is_goverment bool NOT NULL);
insert into account (number, is_goverment) values ('40817', false);
insert into account (number, is_goverment) values ('40120', true);

--Государственный счета не должен видеть пользователь jenya. 
--Создадим view, который будет показывать только негосударственные счета и дадим доступ jenya к этому view
create view non_goverment_account as (select * from account where is_goverment = false);
--Даем доступ ко view
grant select on table non_goverment_account to jenya;
--Удаляем доступ к таблице account
revoke select on table account from jenya;

--Включим роль jenya
set role jenya;
--Jenya может видеть негосударственные счета
select *
from non_goverment_account;




create table car (id serial primary key, name varchar(50));

insert into car (name) values ('audi3');

select *
from car;

--Последовательность (sequence)
select currval('car_id_seq'); -- текущение значение
select nextval('car_id_seq'); -- новое значение
select setval('car_id_seq', 1); -- установка значения

--Создание сиквенса самостоятельно
create sequence my_first_seq START 1000 INCREMENT 2;


--Задача: генерировать номера мест в кинозале - 1А, 2А, 3А
create sequence place_seq;

--ФУНКЦИЯ генерации номеров мест
create or replace function generate_place()
 returns varchar -- тип возвращаемых данных
 language plpgsql -- встроенный процедурный язык postgres 
 as $$ -- начало тела функции
 begin -- начало транзакции
 	return nextval('place_seq') || 'A';
 end; 
$$; 

--Перегрузка функции (другая сигнатура)
create or replace function generate_place(postfix varchar)
 returns varchar
 language plpgsql -- встроенный процедурный язык postgres 
 as $$
 begin
 	return nextval('place_seq') || postfix;
 end; 
$$; 

--Вызов функции
select generate_place('B');

--Создание таблицы мест
create table place (id serial primary key, name varchar(10) default generate_place());

--Вставка без значений (будут вставлены значения по умолчанию)
insert into place default values;

--создание последовательности с начальным номером 1005
create sequence code_seq start 1005;

--Хранимая процедура - аналогично функции но без возврата значений
--Процедура создания продукта - передается название продукта, цена, имя производителя
create or replace procedure create_product(_name varchar, _price numeric, _producer_name varchar)
  language plpgsql
  as $$
  	declare 
	  _producer_id int;
  	begin
		_producer_id = (select id from producer where name = _producer_name);
		if _producer_id is null then
			raise exception 'Производителя с таким именем нет: %', _producer_name;
		end if;
		insert into product (code, name, price, producer_id) values 
		(nextval('code_seq'), _name, _price, _producer_id);
	end;  
 $$;

--Вызов процедуры (создание продукта)
call create_product('горошек', 100, 'Бондюэль'); 


--Процедура, которая создает таблицу orders, и заполняет n значений
create procedure create_and_fill_orders(count int)
 language plpgsql
 as $$
 	declare
	i int;
 	begin
		create table if not exists orders(id serial primary key);		
		for i in 1..count loop
			insert into orders default values;
		end loop;
	end;
 $$;

--Вызов процедуры
call create_and_fill_orders(1000);
 
--Подключение дополнительного функционала (функций, процедур и других объектов)
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
 
--TRUNCATE TABLE movie, ticket, place, session RESTART IDENTITY CASCADE
--drop table producer cascade;

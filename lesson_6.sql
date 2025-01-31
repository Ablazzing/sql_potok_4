--Таблица товаров с остатками
create table good (id serial primary key, name varchar(50), qty int);
--Вставить товар "Водка"
insert into good (name, qty) values ('Вода', 10);

--Таблица заказов
create table orders (id serial primary key, good_id int references good(id), qty int);

--Поменять количество водки
update good set qty = 2 where id = 1;

--Вставить в заказ товар (или группу товаров), если их количество больше '0'
do $$ --Начало скриптового языка (не чистый sql)
	declare --Объявление переменных
	  water_id int := 1;
	  water_qty int;
	begin --Начало блока транзакции
		water_qty := (select qty from good where id = water_id);
		--raise notice 'qty water: %', water_qty; - аналог System.out.println
		insert into orders (good_id, qty) values (water_id, 1);
		--delete from good where id = 1; - Порождает ошибку и как следствие rollback
		perform pg_sleep(10);
		
		if water_qty > 0 then		  
		  update good set qty = qty - 1 where id = water_id;
		  --raise notice 'water greater than 0';			
		else
		  --rollback; - команда отката
		  raise notice 'Воды меньше или равно 0!';
		end if;
	end;
$$
--Транзакция - это блок кода, который будет исполнен либо полностью, либо не исполнен вообще
--ACID
--A - ATOMICITY - Атомарность
--C - CONSISTENCY - Консистентность
--I - ISOLATION - Изоляционность
--D - DURABILITY - Отказоустоичивость

--ЧАСТЬ 2
--В таблице продукт есть продукты разных производителей
--Задача: под каждого производителя создать таблицу с его номером с его товарами
select *
from product;

--Результат работы - появление таблиц с названиями
--producer_1
--producer_2
--producer_3
--где producer_[id производителя товара из таблицы продукт]

--Решение
do $$
  declare
    result_row record;
    current_producer_id int;
	c_table_name varchar;
  begin  
    for result_row in (select distinct producer_id from product) loop --Построчный перебор запроса (курсор)
		current_producer_id := result_row.producer_id;
		--raise notice 'producer %', current_producer_id;
		c_table_name := 'producer_' || current_producer_id;
		--raise notice '%', c_table_name;
		execute 'create table ' || c_table_name || ' (code int primary key, "name" varchar)';	
		execute 'insert into '  || c_table_name || ' select code, "name" from product where producer_id = ' || current_producer_id;
	end loop;
  end;
$$


--Пропустить первые три строчки в запросе (не относится к задаче)
select *
from (
	select *, row_number() over(order by price) as rn
	from product
) as t1
where rn > 3

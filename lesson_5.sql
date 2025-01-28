--Добавим нового производителя
INSERT INTO public.producer(
	id, country, name, address_real, address_jur)
	VALUES (3, 'Турция', 'Турецкие авиалинии', 'Анталья', 'Оренбург');	
	
--Добавим Икру в продукты
insert into product values(1004, 'Икра', 1200, 3);


--Создание электронных товаров
CREATE TABLE IF NOT EXISTS public.electronic_product
(
    code serial PRIMARY KEY,
    name character varying(50),
    price numeric(10,2),
    producer_id integer references producer(id)
);
--Наполнение электронных товаров
insert into electronic_product (name, price, producer_id) values ('Мышка', 500, null);

--Объединить электронные товары со съедобными товарами (таблица product)
select *
from product
union
select *
from electronic_product


-- select *
-- from (
-- 	select *
-- 	from product
-- 	union
-- 	select *
-- 	from electronic_product
-- ) as t1
-- where price > 100;

--Добавить колонку со средним значением по всем продуктам
select *, (select avg(price) from product) as avg_price
from product


--Добавить колонку со средним по наименованию продукта
select p.*, t1.avg_price
from (
select name, avg(price) as avg_price
from product
group by name) as t1 join product p on t1.name = p.name

--Тоже самое через подзапрос
select *, (select avg(price) from product p2 where p1.name = p2.name )
from product p1;



--Вычислить количество продуктов одинаковым именем (доп колонка)
select *, (select count(*) from product p2 where p1.name = p2.name)
from product p1;

--Тоже самое через оконную функцию
select *, count(*) over(partition by name)
from product;

--Самая дешевая цена для имени продукта
select *, min(price) over(partition by name)
from product;

--Оставить продукты у который четный код
select *
from product
where code % 2 = 0;

--Оставить только четные продукты которые отсортированы по цене
--row_number() - функция генерящее номер строки
select *
from (
	select *, row_number() over(order by price) as row_num
	from product
) as t1
where row_num % 2 = 0;

--Выбрать два продукта - хлеб и масло
select *
from product
where name in ('Масло', 'Хлеб');

--Выбрать только тех производителей у которых юридический адрес содержит букву "о"
select *
from producer
where lower(address_jur) like '%о%';
	
	
--Выбрать только те продукты, у которых производители имеют юридический адрес с буквой "а"	
select product.*
from product join producer on product.producer_id = producer.id
where lower(address_jur) like '%а%';

--Вариант с подзапросом
select *
from product
where producer_id in (
	select id
	from producer
	where lower(address_jur) like '%а%'
);

--Определить дешевый товар или дорогой
select *, case when price < 150 then true else false end "Дешевый"
from product;

--Сохранить результат select в новую таблицу (если таблица уже существует, будет ошибка)
select * into all_product
from (
	select *
	from product
	union
	select *
	from electronic_product
) as t1
where price > 100;

--Добавить результат в существующую таблицу
insert into all_product
select *
from (
	select *
	from product
	union
	select *
	from electronic_product
) as t1
where price > 100;

--Временная таблица, существующая только в момент запроса
with cte as (
	select *
	from producer
	where lower(address_jur) like '%а%'
)

select *
from product
where producer_id in (select id from cte);


--Создание view (хранит в себе запрос, который исполняется при обращении к этой view)
create view expensive_product as (
	select *
	from product
	where price < 150
);

--Работа с view
select *
from expensive_product;

--Удаление view
drop view expensive_product;

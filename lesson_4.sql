
--Количество строк в таблице product
select count(*) "Количество товаров"
from product p;

select *
from product;

insert into product values(1003, 'Масло', 200, 2);

--Средняя стоимость масла в магазине
select avg(price)
from product p
where p."name" = 'Масло';

--Сумма стоимости всех продуктов
select sum(price)
from product;

--Максимальная стоимость продукта
select max(price) "Максимальная стоимость продукта"
from product;

--Минимальнаяс стоимость продукта
select min(price) "Минимальная стоимость продукта"
from product;

--КОЛИЧЕСТВО ПРОДУКТОВ С МАКСИМАЛЬНОЙ ЦЕНОЙ (Из Таблицы продукт) ДЛЯ КАЖДОЙ КОМПАНИИ
select producer_name, count(*)
from (
	--Продукты с максимальной стоимостью + их производитель
	select p."name", p.price, pr.name as producer_name
	from (
		select name, max(price) as max_price
		from product
		group by name 
	) as t1 inner join product p on t1.name = p.name and t1.max_price =  p.price
		inner join producer pr on pr.id = p.producer_id 
) as t2
group by producer_name

--Показать уникальные имена продуктов
select distinct name
from product;


--Показать среднюю цену для каждого наименования продукта
select name, avg(price)
from product
group by name
having avg(price) > 150;

--аналогичен запросу выше
select *
from (
	select name, avg(price) avg_price
	from product
	group by name
) as t1
where avg_price > 150;

create table orders (id serial primary key, address varchar(50), date timestamp);

insert into orders (address, date) values ('Москва', NOW());

--Поиск заказов между двумя датами (включительно)
select *
from orders
where date between '2024-10-10' and '2024-10-11' and address = 'Париж';

--Поиск заказов за 2025 год
select *
from orders
where extract(year from date) = 2025

--Показать список заказов и количество дней с момента заказа
select *, extract(day from (now() - o.date)) "Количество дней от заказа (на сегодня)"
from orders o;


--Показать товары по убыванию цены
select *
from product
order by price desc;

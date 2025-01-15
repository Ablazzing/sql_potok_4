--Создание таблицы "продукт"
create table product (code int,
					 "name" varchar(50),
					  price money,
					  country_producer varchar(50),
					  company_producer varchar(100)
					 );
					 

--Выборка всех строк (и всех колонок) из таблицы
--select не изменяет данные!
select *
from product;

--Вставка записи в таблицу (создание продукта)
insert into product values(1001, 'Масло', 120.1, 'Россия', 'Вологодское масло');
insert into product values(1002, 'Хлеб', 35, 'Россия', 'Дарница');

--Посмотреть все имена и цены продуктов
select "name", price
from product;

--Посмотреть только те продукты, у которых артикул 1001 (отобразить все столбцы)
select *
from product
where code = 1001;

--Посмотреть только те продукты, которые стоят больше 50 и страна производитель "Россия"
select *
from product
where price > cast(50 as money) and country_producer = 'Россия';

--Изменить цену масла на 130 рублей
update product set price = cast(130 as money)
where "name" = 'Масло';

--Прибавить ко всем ценам 10 рублей
update product set price = price + cast(10 as money);

--Создать продукт 1003, Водка, 1000 рублей, Россия, неизвестный производитель'
--null - Отсутствие значения (не текст!)
insert into product values(1003, 'Водка', 1000.0, 'Россия', null);

--При выборке компании производитель, добавить фразу "из Москвы" (конкатенация строк)
select company_producer || 'из Москвы' 
from product;

--Операции которые в которых участвуют два значения, одно из которых null, порождают null
--1 + null -> null - сложение с null
--'Текст' || null -> null - конкатенация с null
--null = null -> null - сравнение через "=" с null

--Единственный оператор, который не порождает null - is
--1 is null -> false - является ли 1 null? Нет (false)
--null is null -> true - является ли null nullom? Да (true)

--Поставить для всех компаний 'Столичная', у которых значение null
update product set company_producer = 'Столичная'
where company_producer is null;

--Удалить строку с водкой
delete from product
where "name" = 'Водка';

--Изменить таблицу существующую таблицу (например добавить колонку) - регион производства
alter table product add column region varchar(50);

--Удалить таблицу
drop table product;

--DDL - DATA DEFINITION LANGUAGE - ЯЗЫК ОПИСАНИЯ ДАННЫХ (создаем, изменяем, удаляем таблицу)
--CREATE, DROP, ALTER

--SQL - ВЫБОРКА ДАННЫХ (выбираем данные из таблицы)
--SELECT

--DML - DATA MANIPULATION LANGUAGE - Язык изменения данных (изменяем данные внутри существующей таблицы)
--UPDATE, DELETE, INSERT


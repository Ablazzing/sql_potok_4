drop table if exists product;

--producer
--уникальный идентификатор	Страна фирмы изготовителя	Фирма изготовитель	Адрес фактический	Адрес Юридический
create table producer (
	id int primary key, 
	country varchar(50), 
	name varchar(50), 
	address_real varchar(200),
	address_jur varchar(200)
);

--Вставка значений
insert into producer values(1, 'Россия', 'Вологодское масло', 'Вологда', 'Вологда');
insert into producer values(2, 'Россия', 'Дарница', 'Вологда', 'Москва');

--Выбор нужных колонок для записей
select id, name, country, address_real, address_jur
from producer;

--product
--Артикул	Наименование продукта	Цена	идентификатор компании
create table product (
	code int primary key,
	name varchar(30),
	price numeric(10, 2),
	producer_id int references producer(id)
);

--Вставка двух продуктов ссылающихся на записи из таблицы producer
insert into product values(1001, 'Масло', 130.234, 1);
insert into product values(1002, 'Хлеб', 35, 2);

--Получение всех продуктов + имя производителя
select product.*, coalesce(producer.name, 'Неизвестный производитель')
from product left join producer on product.producer_id = producer.id;

--Аналог inner join
select product.*, producer.name
from product, producer
where product.producer_id = producer.id;

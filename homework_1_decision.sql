-- Sql дз Университет
-- (Залить в репозиторий и отправить все скрипты из всех частей)
-- Создаем схему Инженерно-экономического университета
-- Часть 1. Создание структуры. Определить самостоятельно типы данных для каждого поля(колонки).
-- Самостоятельно определить что является primary key и foreign key.
-- 1. Создать таблицу с факультетами: id, имя факультета, стоимость обучения
-- 2. Создать таблицу с курсами: id, номер курса, id факультета
-- 3. Создать таблицу с учениками: id, имя, фамилия, отчество, бюджетник/частник, id курса
create table faculty (id serial primary key, name varchar(100), price numeric (10,2));
create table course (id serial primary key, "number" varchar(10), faculty_id int references faculty(id));
create table student (
	id serial primary key, 
	"name" varchar(50), 
	"lastname" varchar(50),
	"surname" varchar(50),
	is_budget bool NOT NULL,
	course_id int references course(id)
);

-- Часть 2. Заполнение данными:
-- 1. Создать два факультета: Инженерный (30 000 за курс) , Экономический (49 000 за курс)
-- 2. Создать 1 курс на Инженерном факультете: 1 курс
-- 3. Создать 2 курса на экономическом факультете: 1, 4 курс
insert into faculty ("name", price) values ('Инженерный', 30000);
insert into faculty ("name", price) values ('Экономический', 49000);

insert into course ("number", faculty_id) values (
	'1', 
	(select id from faculty where "name" = 'Инженерный')
);

insert into course ("number", faculty_id) values (
	'1', 
	(select id from faculty where "name" = 'Экономический')
);

insert into course ("number", faculty_id) values (
	'4', 
	(select id from faculty where "name" = 'Экономический')
);

-- 4. Создать 5 учеников:
-- Петров Петр Петрович, 1 курс инженерного факультета, бюджетник
-- Иванов Иван Иваныч, 1 курс инженерного факультета, частник
-- Михно Сергей Иваныч, 4 курс экономического факультета, бюджетник
-- Стоцкая Ирина Юрьевна, 4 курс экономического факультета, частник
-- Младич Настасья (без отчества), 1 курс экономического факультета, частник
insert into student ("name", "surname", "lastname", is_budget, course_id) values (
	'Петр', 
	'Петрович', 
	'Петров', 
	true, 
	( 
	 select c.id
	 from course c join faculty f on c.faculty_id = f.id
	 where "number" = '1' and f.name = 'Инженерный'
	)
),
(
	'Иван', 
	'Иваныч', 
	'Иванов', 
	false, 
	( 
	 select c.id
	 from course c join faculty f on c.faculty_id = f.id
	 where "number" = '1' and f.name = 'Инженерный'
	)
),
(
	'Сергей', 
	'Иваныч', 
	'Михно', 
	true, 
	( 
	 select c.id
	 from course c join faculty f on c.faculty_id = f.id
	 where "number" = '4' and f.name = 'Экономический'
	)
),
(
	'Ирина', 
	'Юрьевна', 
	'Стоцкая', 
	false, 
	( 
	 select c.id
	 from course c join faculty f on c.faculty_id = f.id
	 where "number" = '4' and f.name = 'Экономический'
	)
),
(
	'Настасья', 
	null, 
	'Младич', 
	false, 
	( 
	 select c.id
	 from course c join faculty f on c.faculty_id = f.id
	 where "number" = '1' and f.name = 'Экономический'
	)
);

-- Часть 3. Выборка данных. Необходимо написать запросы, которые выведут на экран:
-- 1. Вывести всех студентов, кто платит больше 30_000.
select s.*
from student s 
	inner join course c on s.course_id = c.id
	inner join faculty f on f.id = c.faculty_id
where is_budget = false and f.price > 30000;
-- 2. Перевести всех студентов Петровых на 1 курс экономического факультета.
update student set course_id = ( 
	 select c.id
	 from course c join faculty f on c.faculty_id = f.id
	 where "number" = '1' and f.name = 'Экономический'
	)
where lastname like 'Петров_' or lastname = 'Петров';
-- 3. Вывести всех студентов без отчества или фамилии.
select *
from student
where lastname is null or surname is null;
-- 4. Вывести всех студентов содержащих в фамилии или в имени или в отчестве "ван". (пример name like '%Петр%' - найдет всех Петров, Петровичей, Петровых)
select *
from student
where lower(lastname) like '%ван%' or lower("name") like '%ван%' or lower(surname) like '%ван%';
-- 5. Удалить все записи из всех таблиц.
delete from student;
delete from course;
delete from faculty;

--Получение возможности работать с uuid
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

--Генерация uuid
select uuid_generate_v4();

drop table if exists test;
--Создание таблицы, у которой id - UUID. Значение автоматически генерируется за счет функции uuid_generate_v4().
create table test (id uuid primary key default uuid_generate_v4(), "name" varchar(50));

insert into test("name") values ('Ivan');

select *
from test;



-- 3. Необходимо составить отчет для менеджеров (отправить ссылку на гитхаб с запросами):
-- 3.1. Посчитать количество заказов за все время. Смотри таблицу orders. Вывод: количество заказов.
select count(*) as qty_orders
from orders;

-- 3.2. Посчитать сумму денег по всем заказам за все время (учитывая скидки).  Смотри таблицу order_details. 
-- Вывод: id заказа, итоговый чек (сумма стоимостей всех  продуктов со скидкой)
select  order_id, sum (
		cast( 
			unit_price * quantity * (1 - discount) as numeric(10,2)
		)
	) as order_sum
from order_details
group by order_id;

-- 3.3. Показать сколько сотрудников работает в каждом городе. 
-- Смотри таблицу employee. Вывод: наименование города и количество сотрудников
select city, count(*) as qty_employee
from employees
where city is not null
group by city;


-- 3.4. Показать фио сотрудника (одна колонка) и сумму всех его заказов 
select first_name || ' ' || last_name, coalesce( 
	sum (		
		cast( 
				unit_price * quantity * (1 - discount) as numeric(10,2)
			)
	), 
	0
) as order_sum
from employees e
	left join orders o on e.employee_id = o.employee_id
	left join order_details od on od.order_id = o.order_id
group by first_name || ' ' || last_name;

-- 3.5. Показать перечень товаров от самых продаваемых до самых непродаваемых (в штуках). 
-- Вывести наименование продукта и количество проданных штук.
select product_name, coalesce(sum(quantity), 0) as sum_quantity
from order_details o right join products p on o.product_id = p.product_id
group by product_name
order by sum_quantity desc;


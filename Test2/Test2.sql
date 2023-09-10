-- 1.
-- объединение с JOIN
SELECT
	a.aircraft_code,
	a.model,
	a."range",
	s.seat_no,
	s.fare_conditions 
FROM bookings.aircrafts a
JOIN bookings.seats s 
ON a.aircraft_code = s.aircraft_code
ORDER BY 1;

-- объединение с UNION
SELECT
	a.aircraft_code,
	a.model AS object
FROM bookings.aircrafts a
UNION
SELECT
	s.aircraft_code,
	s.fare_conditions AS object
FROM bookings.seats s 
ORDER BY 1;

-- 2. запрос с любым фильтром
-- WHERE к произвольной таблице и результат отсортируйте(ORDERBY)с ограничением вывода по количеству строк(LIMIT)

select aircraft_code, model, range
from bookings.aircrafts a 
where "range" >= 3000
order by "range" desc
limit 5;

-- 3. OLAP запрос к произвольной связке таблиц(врамках JOIN оператора),
-- используя оператор GROUP BY и любые агрегатные функции count,min,max,sum.

SELECT
	t.passenger_name,
	count(1),
	min(tf.amount),
	max(tf.amount),
    sum(tf.amount)
FROM bookings.tickets t
JOIN bookings.ticket_flights tf ON t.ticket_no = tf.ticket_no
GROUP BY t.passenger_name
ORDER BY count DESC;

-- 4. примените JOIN операторы(INNER,LEFT,RIGHT)для более чем двух таблиц.

SELECT
	t.passenger_name,
	tf.fare_conditions,
	tf.amount,
	bp.seat_no
FROM bookings.tickets t
JOIN bookings.ticket_flights tf ON t.ticket_no =tf.ticket_no
JOIN bookings.boarding_passes bp ON tf.ticket_no = bp.ticket_no
ORDER BY 1;

-- 5. VIEW из задания 2.

create or replace view aircrafts_vw as
	select aircraft_code, model, range
	from bookings.aircrafts a 
	where "range" >= 3000
	order by "range" desc
    limit 5;

select * from aircrafts_vw;
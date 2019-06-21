#---------------------------------------------------------------------------------------------------------------------------1er requête :

SELECT employee_id, e.last_name, e.first_name
	FROM t_reservation
	NATURAL JOIN t_employee e
	WHERE employee_id = (
	SELECT MAX(employee_id)
   	 FROM t_reservation
   	 );

#---------------------------------------------------------------------------------------------------------------------------2eme requête:   

SELECT buyer_id, c.customer_id, c.last_name, c.first_name
	FROM t_reservation
	NATURAL JOIN t_customer c
	WHERE buyer_id <> c.customer_id
	ORDER BY last_name, first_name;

#---------------------------------------------------------------------------------------------------------------------------3eme requête:

SELECT r.reservation_id "Numéro rés", r.creation_date "Date créa", e.last_name, e.first_name, c.last_name, c.first_name
	FROM t_reservation r 
	JOIN t_customer c
		ON (c.customer_id = r.buyer_id)
	JOIN t_employee e
		ON (r.employee_id = e.employee_id)
	WHERE r.creation_date = (SELECT MIN(r.creation_date) FROM t_reservation r);


#---------------------------------------------------------------------------------------------------------------------------4eme requête :

SELECT c.last_name, c.first_name, c.pass_date, p.pass_name
FROM t_customer c
JOIN t_pass p
ON c.pass_id = p.pass_id
WHERE pass_date > TO_DATE('15/01/19','DD/MM/RR')
UNION
SELECT c.last_name, c.first_name, c.pass_date, REPLACE(p.pass_name, p.pass_name, 'Périmé !')
FROM t_customer c
JOIN t_pass p
ON c.pass_id = p.pass_id
WHERE pass_date < TO_DATE('15/01/19','DD/MM/RR')
UNION
SELECT c.last_name, c.first_name, c.pass_date, REPLACE(p.pass_name, p.pass_name, 'Aucun')
FROM t_customer c
JOIN t_pass p
ON c.pass_id = p.pass_id
WHERE c.pass_id IS NULL;


#---------------------------------------------------------------------------------------------------------------------------5eme requête:

SELECT train_id, departure_station_id, s.city, TO_CHAR(departure_time,'HH24:MI:SS') AS "heure départ", arrival_station_id, a.city, TO_CHAR(arrival_time,'HH24:MI:SS') AS "heure arriver", distance, price
	FROM t_train
	NATURAL JOIN t_station s
	JOIN t_station a
		ON(a.station_id=s.station_id)
	WHERE departure_station_id = station_id or arrival_station_id = station_id 
	ORDER BY train_id;


#---------------------------------------------------------------------------------------------------------------------------8eme requête:

SELECT last_name, first_nam, address
	FROM t_customer
	WHERE pass_id IS NULL
	ORDER BY last_name, first_name;

#---------------------------------------------------------------------------------------------------------------------------9eme requête:

SELECT t.train_id, a.city, s.city, t.distantce/((t.arrival_time-t.departure_time) *24) as “km/h”
	FROM t_train t
	JOIN t_station s
		ON (t.departure_station_is = s.station_id)
	JOIN t_station a
		ON (t.arrivale_station_id = a.station_id);

#---------------------------------------------------------------------------------------------------------------------------10eme requête:

SELECT p.pass_name, COUNT(c.customer_id)
	FROM t_train t
	JOIN t_wagon_train w 
ON w.train_id = t.train_id
            JOIN t_ticket i 
ON i.wag_tr_id = wt.wag_tr_id
JOIN t_reservation r 
ONr.reservation_id = ti.reservation_id
JOIN t_customer c 
ON c.customer_id = r.buyer_id
JOIN t_pass p 
ON c.pass_id = p.pass_id
JOIN t_pass p
 ONc.pass_id = p.pass_id
WHERE p.pass_name LIKE 'senior' AND t.departure_time LIKE '%03%'
GROUP BY p.pass_name;


#---------------------------------------------------------------------------------------------------------------------------12eme requête:

SELECT p.pass_name, COUNT(customer_id)
	FROM t_pass p
	JOIN t_customer c 
		ON (pass_id = c.pass_id)
	GROUPE BY p.pass_name
	ORDER BY customer_id DESC;

#---------------------------------------------------------------------------------------------------------------------------16eme requête:

SELECT employee_id, last_name, salary + 100
	FROM t_employee
	WHERE manager_id = (SELECT employee_id 
    FROM t_employee
   WHERE manager_id is null );

# SPRINT 2. SQL
USE transactions;
# NIVEL 1

# - Ejercicio 2
# Utilizando JOIN realizarás las siguientes consultas:

# Listado de los países que están generando ventas.
SELECT DISTINCT c.country 
FROM company c
JOIN transaction t ON c.id=t.company_id
WHERE t.declined=0;


# Desde cuántos países se generan las ventas.
SELECT COUNT(DISTINCT country) AS Países_que_compran
FROM company c
JOIN transaction t ON c.id=t.company_id
WHERE t.declined=0;


# Identifica a la compañía con la mayor media de ventas.
SELECT c.id, c.company_name, ROUND(AVG(t.amount),2) AS media_de_ventas
FROM company c
JOIN transaction t ON c.id=t.company_id
WHERE t.declined=0
GROUP BY c.id, c.company_name
ORDER BY media_de_ventas DESC
LIMIT 1;


# - Ejercicio 3
# Utilizando sólo subconsultas (sin utilizar JOIN):

# Muestra todas las transacciones realizadas por empresas de Alemania.
SELECT id
FROM transaction
WHERE company_id IN (SELECT id
FROM company 
WHERE country ="Germany");


# Lista las empresas que han realizado transacciones por un amount superior a la media de todas las transacciones.
SELECT c.id, c.company_name
FROM company c
WHERE EXISTS
	(SELECT t.company_id
    FROM transaction t
    WHERE t.company_id = c.id
		AND t.amount> (SELECT AVG(amount) FROM transaction));
        

# Eliminarán del sistema las empresas que carecen de transacciones registradas, entrega el listado de estas empresas.
SELECT c.id, c.company_name
FROM company c
WHERE NOT EXISTS 
	(SELECT t.company_id
	FROM transaction t
    WHERE t.company_id=c.id);
    

# NIVEL 2

# Ejercicio 1
# Identifica los cinco días que se generó la mayor cantidad de ingresos en la empresa por ventas. Muestra la fecha de cada transacción junto con el total de las ventas.

SELECT DATE(timestamp) AS fecha, SUM(amount) AS total_de_ventas
FROM transaction
WHERE declined=0
GROUP BY fecha
ORDER BY SUM(amount) DESC
LIMIT 5; 


# Ejercicio 2
# ¿Cuál es la media de ventas por país? Presenta los resultados ordenados de mayor a menor medio.

SELECT c.country, ROUND(AVG(t.amount),2) AS media_de_ventas
FROM transaction t
JOIN company c ON t.company_id=c.id
WHERE declined=0
GROUP BY c.country
ORDER BY AVG(t.amount) DESC;


# Ejercicio 3
# En tu empresa, se plantea un nuevo proyecto para lanzar algunas campañas publicitarias para hacer competencia a la compañía “Non Institute”. 
# Para ello, te piden la lista de todas las transacciones realizadas por empresas que están ubicadas en el mismo país que esta compañía.


# Muestra el listado aplicando JOIN y subconsultas.
SELECT t.id, c.id, c.company_name, c.country # podría también mostrar el timestamp, el monto y si fue declinada o no
FROM transaction t
JOIN company c ON t.company_id=c.id
WHERE c.country=
	(SELECT country
	FROM company
	WHERE company_name ='Non Institute');
  
  
# Muestra el listado aplicando solo subconsultas.
    SELECT t.id
FROM transaction t
WHERE EXISTS 
	(SELECT c.id
	FROM company c
	WHERE t.company_id=c.id
    AND c.country=
		(SELECT country
		 FROM company
		 WHERE company_name ='Non Institute'));


# NIVEL 3


# Ejercicio 1
# Presenta el nombre, teléfono, país, fecha y amount, 
# de aquellas empresas que realizaron transacciones con un valor comprendido entre 100 y 200 euros 
# y en alguna de estas fechas: 29 de abril de 2021, 20 de julio de 2021 y 13 de marzo de 2022. 
# Ordena los resultados de mayor a menor cantidad.

SELECT  c.company_name, c.phone, c.country, DATE(t.timestamp) AS fecha, t.amount
FROM company c
JOIN transaction t ON c.id=t.company_id
WHERE (t.amount BETWEEN 100 AND 200) AND DATE(t.timestamp) IN('2021-04-29', '2021-07-20', '2022-03-13')
ORDER BY t.amount DESC;


# Ejercicio 2
# Necesitamos optimizar la asignación de los recursos y dependerá de la capacidad operativa que se requiera, por lo que te piden la información sobre 
# la cantidad de transacciones que realizan las empresas, pero el departamento de recursos humanos es exigente y 
# quiere un listado de las empresas en las que especifiques si tienen más de 4 transacciones o menos.
SELECT t.company_id, c.company_name, COUNT(t.id) AS cantidad_de_trasacciones,
		CASE 
			WHEN COUNT(t.id) > 4 THEN 'Sí'
			ELSE 'No'
		END AS mas_de_4_transacciones
FROM transaction t
JOIN company c ON t.company_id=c.id
GROUP BY t.company_id;
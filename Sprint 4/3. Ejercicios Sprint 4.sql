-- NIVEL 1
-- Ejercicio 1
SELECT u.id, u.name, u.surname, u.region, u.country
FROM users u
WHERE u.id IN
	(SELECT t.user_id
	FROM transaction t
	GROUP BY t.user_id
	HAVING COUNT(t.id)>80);

-- Ejercicio 2
SELECT c.iban, ROUND(AVG(t.amount),2) AS transaccion_media 
FROM credit_cards c 
JOIN transaction t ON c.id=t.card_id
JOIN companies co ON co.id=t.business_id
WHERE co.company_name= 'Donec Ltd'
GROUP BY c.iban;

-- NIVEL 2
-- Ejercicio 1

CREATE TABLE IF NOT EXISTS card_status AS
WITH ultimas AS 
    (SELECT card_id, declined, timestamp,
        ROW_NUMBER() OVER (PARTITION BY card_id ORDER BY timestamp DESC) AS rn
    FROM transaction),
    tres AS 
    (SELECT *
    FROM ultimas
    WHERE rn <= 3)
SELECT card_id,
    CASE
        WHEN SUM(declined) = 3 THEN 'inactivo'
        ELSE 'activo'
    END AS estado
FROM tres
GROUP BY card_id;


SELECT COUNT(*) AS activas
FROM card_status
WHERE estado='activo';


-- NIVEL 3
-- Ejercicio 1

CREATE TABLE IF NOT EXISTS transaction_products AS
SELECT t.id AS transaction_id, jt.product_id
FROM transaction t
JOIN JSON_TABLE
(CONCAT('[', t.product_ids, ']'),
'$[*]' COLUMNS( product_id INT PATH '$' )) AS jt;

ALTER TABLE transaction_products
ADD PRIMARY KEY (transaction_id, product_id),
ADD CONSTRAINT fk_tp_transaction
    FOREIGN KEY (transaction_id) REFERENCES transaction(id),
ADD CONSTRAINT fk_tp_product
    FOREIGN KEY (product_id) REFERENCES products(id);
    
SELECT tp.product_id, p.product_name, COUNT(*) AS veces_vendido
FROM transaction_products tp
JOIN products p ON tp.product_id = p.id
GROUP BY tp.product_id, p.product_name;
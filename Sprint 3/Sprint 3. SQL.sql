-- SPRINT 3.
-- NIVEL 1.
-- Ejercicio 1.
USE transactions;
-- NIVEL 1.
-- Ejercicio 1.
    -- Paso 1. Creamos la tabla credit_card
    CREATE TABLE IF NOT EXISTS credit_card (
        id VARCHAR(20) PRIMARY KEY,
        iban VARCHAR(50),
        pan VARCHAR(50),
        pin VARCHAR(4),
        cvv VARCHAR(3),
        expiring_date VARCHAR(25)
    );

-- Paso 2. Ingresamos los datos (utilizando el archivo "datos_introducir_sprint3_credit.sql")

-- Paso 3. Creamos la relación con la tabla transaction
ALTER TABLE transaction 
ADD CONSTRAINT fk_transaction_credit_card
FOREIGN KEY (credit_card_id) REFERENCES credit_card(id); 


-- Ejercicio 2.
-- Actualizamos el IBAN de la tarjeta con ID CcU-2938
UPDATE credit_card
SET iban = 'TR323456312213576817699999'
WHERE id = 'CcU-2938';

-- Verificamos el cambio
SELECT *
FROM credit_card
WHERE id ='CcU-2938';

-- Ejercicio 3.
INSERT INTO credit_card(id) 
VALUES ('CcU-9999');

INSERT INTO company(id) 
VALUES ('b-9999');

-- Insertamos datos de la transacción a la tabla “transaction”
INSERT INTO transaction (id, credit_card_id, company_id, user_id, lat, longitude, amount, declined) 
VALUES ('108B1D1D-5B23-A76C-55EF-C568E49A99DD', 'CcU-9999', 'b-9999', '9999', 829.999, -117.999, 111.11, 0);


-- Ejercicio 4.
ALTER TABLE credit_card
DROP COLUMN pan;

-- NIVEL 2.

-- Ejercicio 1.
DELETE FROM transaction
WHERE id='000447FE-B650-4DCF-85DE-C7ED0EE1CAAD';

-- Ejercicio 2. 
-- Creamos la VistaMarketing
CREATE VIEW VistaMarketing AS
SELECT c.company_name, c.phone, c.country, ROUND(AVG(t.amount),2) AS media_compra  
FROM company c  
JOIN transaction t ON c.id=t.company_id
GROUP BY c.company_name, c.phone, c.country
ORDER BY media_compra DESC;

-- Visualizamos la VistaMarketing
SELECT * FROM VistaMarketing;


-- Ejercicio 3.
-- Visualizamos las compañías de Alemania
SELECT * 
FROM VistaMarketing
WHERE country='Germany';


-- NIVEL 3.

-- Ejercicio 1.

 -- Paso 1. Creamos la tabla user
    CREATE TABLE IF NOT EXISTS data_user (
        id INT PRIMARY KEY,
        name VARCHAR(100),
        surname VARCHAR(100),
        phone VARCHAR(150),
        personal_email VARCHAR(150),
        birth_date VARCHAR(100),
        country VARCHAR(150),
        city VARCHAR(150),
        postal_code VARCHAR(100),
        address VARCHAR(255)
    );

-- Paso 2. Insertar datos (utilizando el archivo "datos introducir sprint3 user.sql")

-- Paso 3. Tabla “user”
-- 3.1. Cambiar el nombre a data_user
ALTER TABLE user
RENAME TO data_user; 

-- 3.2. Cambiar tipo de “id”
ALTER TABLE data_user
MODIFY COLUMN id INT;

-- 3.3. Cambiar el nombre de “email” a “personal_email”
ALTER TABLE data_user
RENAME COLUMN email to personal_email;


-- Paso 4. Tabla "transaction"
-- 4.1. Creamos la conexión con “data_user”
ALTER TABLE transaction 
ADD CONSTRAINT fk_transaction_data_user
FOREIGN KEY (user_id) REFERENCES data_user(id); 

-- Revisar los huérfanos 
SELECT DISTINCT user_id
FROM transaction
WHERE user_id NOT IN (SELECT id FROM data_user);

-- Insertamos el usuario a la tabla data_user
INSERT INTO data_user (id)
VALUES (9999);

-- Creamos la conexión con “data_user”
ALTER TABLE transaction 
ADD CONSTRAINT fk_transaction_data_user
FOREIGN KEY (user_id) REFERENCES data_user(id); 

-- Cambiamos la longitud de “credit_card_id”:
ALTER TABLE transaction 
MODIFY credit_card_id VARCHAR(20);

-- Paso 5. Tabla “credit_card”
-- 5.1. Cambiar CVV de VARCHAR a INT
ALTER TABLE credit_card
MODIFY cvv INT;

-- 5.2. Añadir la columna “fecha_actual” de tipo DATE
ALTER TABLE credit_card
ADD fecha_actual DATE;

-- Paso 6. Tabla “company”
-- 6.1. Eliminar la columna “website”
ALTER TABLE company
DROP COLUMN website;


-- Ejercicio 2.
-- Paso 1. Crear la vista InformeTecnico
CREATE VIEW InformeTecnico 
AS SELECT t.id AS id_transaccion, u.name AS nombre, u.surname AS apellido, cr.iban, co.company_name AS compañía   
FROM transaction t
JOIN data_user u ON t.user_id=u.id
JOIN credit_card cr ON t.credit_card_id=cr.id 
JOIN company co ON t.company_id=co.id;

-- Paso 2. Mostrar la vista ordenando por id
SELECT *
FROM InformeTecnico
ORDER BY id_transaccion DESC;

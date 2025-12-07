	-- Creamos la base de datos
	CREATE DATABASE IF NOT EXISTS sprint_4;
	USE sprint_4;

	-- Creamos la tabla users
	CREATE TABLE IF NOT EXISTS users (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    surname VARCHAR(100),
    phone VARCHAR(50),
    email VARCHAR(100),
    birth_date DATE,
    country VARCHAR(100),
    city VARCHAR(100),
    postal_code VARCHAR(20),
    address VARCHAR(255),
    region VARCHAR(20)
	);

    -- Creamos la tabla companies
    CREATE TABLE IF NOT EXISTS companies (
        id VARCHAR(100) PRIMARY KEY,
        company_name VARCHAR(255),
        phone VARCHAR(15),
        email VARCHAR(100),
        country VARCHAR(100),
        website VARCHAR(255)
    );

	-- Creamos la tabla products
    CREATE TABLE IF NOT EXISTS products (
	id INT PRIMARY KEY,
	product_name VARCHAR(100),
	price DECIMAL(10, 2),
	colour VARCHAR(20),
	weight DECIMAL(10, 2),
	warehouse_id VARCHAR(15)
    );

    -- Creamos la tabla transaction
    CREATE TABLE IF NOT EXISTS transaction (
        id VARCHAR(100) PRIMARY KEY,
        card_id VARCHAR(20),
        business_id VARCHAR(100),
        timestamp TIMESTAMP,
        amount DECIMAL(10, 2),
        declined BOOLEAN,
        product_ids VARCHAR(255),
        user_id INT,
        lat FLOAT,
        longitude FLOAT
    );

	-- Creamos la tabla credit_cards
    CREATE TABLE IF NOT EXISTS credit_cards (
        id VARCHAR(20) PRIMARY KEY,
	user_id INT,
        iban VARCHAR(50),
        pan VARCHAR(50),
        pin VARCHAR(4),
        cvv VARCHAR(3),
	track1 VARCHAR(60),
	track2 VARCHAR(60),
        expiring_date DATE
    );
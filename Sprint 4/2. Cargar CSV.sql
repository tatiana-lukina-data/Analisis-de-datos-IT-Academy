SET GLOBAL local_infile=1;

SHOW VARIABLES LIKE 'local_infile';

SHOW VARIABLES LIKE 'secure_file_priv';

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/american_users.csv'
INTO TABLE users
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id, name, surname, phone, email, @birth_date, country, city, postal_code, address)
SET birth_date = STR_TO_DATE(@birth_date, '%b %d, %Y'),
    region='american';

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/european_users.csv'
INTO TABLE users
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id, name, surname, phone, email, @birth_date, country, city, postal_code, address)
SET birth_date = STR_TO_DATE(@birth_date, '%b %d, %Y'),
    region='european';

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/products.csv'
INTO TABLE products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id, product_name, price, colour, weight, warehouse_id)
SET price = REPLACE(@price,'$','');

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/companies.csv'
INTO TABLE companies
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id, company_name, phone, email, country, website);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/credit_cards.csv'
INTO TABLE credit_cards
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id, user_id, iban, pan, pin, cvv, track1, track2, @exp_date)
SET expiring_date = STR_TO_DATE(@exp_date, '%m/%d/%y');

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/transactions.csv'
INTO TABLE transaction
FIELDS TERMINATED BY ';' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id, card_id, business_id, timestamp, amount, declined, product_ids, user_id, lat, longitude);

ALTER TABLE transaction
ADD CONSTRAINT fk_transaction_card
    FOREIGN KEY (card_id) REFERENCES credit_cards(id),
ADD CONSTRAINT fk_transaction_company
    FOREIGN KEY (business_id) REFERENCES companies(id),
ADD CONSTRAINT fk_transaction_user
    FOREIGN KEY (user_id) REFERENCES users(id);
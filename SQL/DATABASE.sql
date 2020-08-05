CREATE DATABASE fridgeInv;
USE fridgeInv;
CREATE TABLE main (
userid VARCHAR(255),
barcode int,
entryTime date);

CREATE TABLE product (
barcode int,
pName VARCHAR(255),
price VARCHAR(255));


DROP TABLE product;
DROP TABLE main;
select * FROM main;
SELECT * FROM product;
INSERT INTO main VALUES ("12345",987654321,'2020-08-05');
INSERT INTO product VALUES (987654321,"Milk","29.99");

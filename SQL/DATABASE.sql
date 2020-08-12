CREATE DATABASE fridgeInv;
USE fridgeInv;
CREATE TABLE main (
userid VARCHAR(255),
barcode Bigint,
entryTime date);

CREATE TABLE product (
barcode bigint,
pName VARCHAR(255),
price VARCHAR(255));

CREATE TABLE mainTesting (
userid VARCHAR(255),
barcode bigint,
entryTime date);

CREATE TABLE productTesting (
barcode bigint,
pName VARCHAR(255),
price float);

DROP TABLE product;
DROP TABLE main;
DROP TABLE productTesting;
DROP TABLE mainTesting;
select * FROM main WHERE userid = 12345;
SELECT * FROM main;
SELECT * FROM product;
ALTER TABLE main MODIFY entryTime datetime;
INSERT INTO main VALUES ("12345",987654321,'2020-08-05');
INSERT INTO product VALUES (987654321,"Milk","29.99");

CREATE DATABASE fridgeInv;
USE fridgeInv;
CREATE TABLE main (
userid VARCHAR(255),
barcode bigint,
entryTime datetime);

CREATE TABLE product (
barcode bigint,
pName VARCHAR(255),
price VARCHAR(255));


DROP TABLE product;
DROP TABLE main;
select * FROM main;
SELECT * FROM product;
INSERT INTO main VALUES ("12345",987654321,'2020-08-05');
INSERT INTO product VALUES (987654321,"Milk","29.99");
INSERT INTO product VALUES (6009617224834,'LW Strawberry Yoghurt 500g','20.00');

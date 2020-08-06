USE fridgeInv;
/*Get: Check if barcode Exists*/ 
SELECT * FROM product WHERE barcode = 987654321;
/*Post New entry*/
INSERT INTO main VALUES ("98765",123456789,"2020-08-04");
/*Get All users products*/
SELECT barcode FROM main WHERE userid = "98765";
SELECT Date(main.entryTime) as entryTime, product.pName,product.price, main.barcode, Count(main.barcode) AS Total FROM main INNER JOIN product ON main.barcode=product.barcode WHERE main.userID = "12345"  group by main.barcode;
SELECT main.entryTime, product.pName,product.price, main.barcode FROM main INNER JOIN product ON main.barcode=product.barcode WHERE main.userID = "12345";
/*Get A users Product total count*/
SELECT Count(barcode) FROM main WHERE userID = "98765" AND barcode= "123456789" AND entryTime BETWEEN '2020-08-01' AND '2020-08-31';
/*Post Entry a new product and user input*/
INSERT INTO product VALUES (123456789,"Eggs","21.99");
INSERT INTO main VALUES ("12345",123456789,"2020-08-04");
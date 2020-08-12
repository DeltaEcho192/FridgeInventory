USE fridgeInv;
INSERT INTO main VALUES ('aF63z0R0jlQR7sfOgBAgOCOsQgv1',987654321,'2020-08-07T10:18:26.438Z');
SELECT * FROM mainTesting;

SELECT productTesting.pName,mainTesting.barcode, Count(mainTesting.barcode), productTesting.price * Count(mainTesting.barcode) AS Total 
FROM mainTesting INNER JOIN productTesting ON mainTesting.barcode=productTesting.barcode group by mainTesting.barcode;

/*Top 5 barcodes with most spent on*/
SELECT productTesting.pName,mainTesting.barcode, Count(mainTesting.barcode),productTesting.price * Count(mainTesting.barcode) AS Total 
FROM mainTesting INNER JOIN productTesting ON mainTesting.barcode=productTesting.barcode 
group by mainTesting.barcode ORDER by Total desc limit 3;

/*Top 5 Most bought barcodes*/
SELECT productTesting.pName,mainTesting.barcode, Count(mainTesting.barcode) AS Total
FROM mainTesting INNER JOIN productTesting ON mainTesting.barcode=productTesting.barcode 
group by mainTesting.barcode ORDER by Total desc limit 3;

/*Total Amount spent in month (if you want year just remove the entry time) Calculation must be done client side*/
SELECT sum(productTesting.price) FROM mainTesting 
inner join productTesting on mainTesting.barcode=productTesting.barcode 
WHERE mainTesting.entryTime BETWEEN '2020-08-01' AND '2020-08-31' AND mainTesting.userid="aF63z0R0jlQR7sfOgBAgOCOsQgv1" 
group by productTesting.price;

/*Total Amount of items bought*/
SElECT COUNT(mainTesting.barcode) AS "Total Items" FROM mainTesting WHERE mainTesting.userid="aF63z0R0jlQR7sfOgBAgOCOsQgv1";

/*Single largest expense*/
SELECT productTesting.pName, productTesting.price
FROM mainTesting JOIN productTesting ON mainTesting.barcode=productTesting.barcode 
group by mainTesting.barcode ORDER by productTesting.price desc limit 1;


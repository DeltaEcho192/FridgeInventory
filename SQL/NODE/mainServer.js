var express = require("express");
var bodyParser = require("body-parser");
const request = require("request");
const bent = require('bent')
const fs = require("fs");
const getJSON = bent('json')
var cors = require('cors')
var path = require('path');
var mysql = require('mysql');
var session = require('express-session');



const app = express();

app.options('*', cors())
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));


app.use((req, res, next) => {
    res.header("Access-Control-Allow-Origin", "*");
    next();
});

var pool = mysql.createPool({
    connectionLimit: 100,
    host: 'localhost',
    user: 'root',
    password: 'xxmaster',
    database: 'fridgeInv'
});


class Database {
    constructor(config) {
        this.connection = mysql.createConnection(config);
    }
    query(sql, args) {
        return new Promise((resolve, reject) => {
            this.connection.query(sql, args, (err, rows) => {
                if (err)
                    return reject(err);
                resolve(rows);
            });
        });
    }
    close() {
        return new Promise((resolve, reject) => {
            this.connection.end(err => {
                if (err)
                    return reject(err);
                resolve();
            });
        });
    }
}

app.get("/check/:bar", (req, res) => {
    var barcodeCheck = "SELECT * FROM product WHERE barcode = " + req.params.bar + ";";
    pool.getConnection(function (err, connection) {
        if (err) throw err;


        connection.query(barcodeCheck, function (error, results, fields) {
            if (results.length > 0) {
                console.log("This product exists")
                res.send(true)
            }
            else {
                console.log("This product does not exist")
                res.send(false)
            }
            connection.release();

            if (error) throw error;
        });
    });
})

app.get("/total/:bar/:userid", (req, res) => {
    var barcode = req.params.bar;
    var userid = req.params.userid;

    var sqlQuery = "SELECT Count(barcode) AS total FROM main WHERE userID = '" + userid + "' AND barcode= " + barcode + " AND entryTime BETWEEN '2020-08-01' AND '2020-08-31';"

    pool.getConnection(function (err, connection) {
        if (err) throw err;

        connection.query(sqlQuery, function (error, results, fields) {
            res.send(results)
            connection.release();

            if (error) throw error;
        });
    });
})

app.get("/all/:userid", (req, res) => {
    var userid = req.params.userid;

    var sqlQuery = "SELECT main.entryTime, product.pName,product.price, main.barcode, Count(main.barcode) AS total FROM main INNER JOIN product ON main.barcode=product.barcode WHERE main.userID = '" + userid + "' group by main.barcode;";
    pool.getConnection(function (err, connection) {
        if (err) throw err;

        connection.query(sqlQuery, function (error, results, fields) {
            res.send(results)
            connection.release();

            if (error) throw error;
        });
    });
})
app.post('/entry', function (req, res) {
    console.log("receiving data...");
    console.log("body is ", req.body);
    var userData = req.body
    if (userData.check == false) {
        var userid = userData.userid
        console.log(userid)
        var barcode = userData.barcode
        var date = userData.date
        var sqlInsert = "INSERT INTO main VALUES ('" + userid + "'," + barcode + ",'" + date + "');"
        console.log(sqlInsert)
        pool.getConnection(function (err, connection) {
            if (err) throw err;

            connection.query(sqlInsert, function (error, results, fields) {
                console.log(results)
                res.status(201)
                connection.release();

                if (error) throw error;
            });
        });
    }
    else {
        var userid = userData.userid
        var barcode = userData.barcode
        var date = userData.date
        var name = userData.name
        var price = userData.price

        var sqlInsertProduct = "INSERT INTO product VALUES (" + barcode + ",'" + name + "','" + price + "');"
        var sqlInsertMain = "INSERT INTO main VALUES ('" + userid + "'," + barcode + ",'" + date + "');";

        pool.getConnection(function (err, connection) {
            if (err) throw err;

            connection.query(sqlInsertProduct, function (error, results, fields) {
                console.log(results)

                if (error) throw error;
            });


            connection.query(sqlInsertMain, function (error, results, fields) {
                console.log(results)
                res.send("Working")
                connection.release();

                if (error) throw error;
            });


        });
    }

})
app.get("/test/", (req, res) => {
    res.send("Being tested")
})

const PORT = process.env.PORT || 9000;
app.listen(PORT, () => console.log(`listening on ${PORT}`));
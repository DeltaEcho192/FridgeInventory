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
const { response } = require("express");
const { Console } = require("console");


const app = express();

app.options('*', cors())
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());


app.use((req, res, next) => {
    res.header("Access-Control-Allow-Origin", "*");
    next();
});


var connection = mysql.createConnection({
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
    database = new Database({
        host: 'localhost',
        user: 'root',
        password: 'xxmaster',
        database: 'fridgeInv'
    })

    var barcodeCheck = "SELECT * FROM product WHERE barcode = " + req.params.bar + ";";
    database.query(barcodeCheck).then(rows => {
        if (rows.length > 0) {
            console.log("This product exists")
        }
        else {
            console.log("This product does not exist")
        }
    })
})

app.get("/total/:bar/:userid", (req, res) => {
    var barcode = req.params.bar;
    var userid = req.params.userid;

    database = new Database({
        host: 'localhost',
        user: 'root',
        password: 'xxmaster',
        database: 'fridgeInv'
    })

    var sqlQuery = "SELECT Count(barcode) AS total FROM main WHERE userID = " + userid + " AND barcode= " + barcode + " AND entryTime BETWEEN '2020-08-01' AND '2020-08-31';"
    database.query(sqlQuery).then(rows => res.send(rows))
})

app.get("/all/:userid", (req, res) => {
    var userid = req.params.userid;

    database = new Database({
        host: 'localhost',
        user: 'root',
        password: 'xxmaster',
        database: 'fridgeInv'
    })

    var sqlQuery = "SELECT main.entryTime, product.pName,product.price, main.barcode FROM main INNER JOIN product ON main.barcode=product.barcode WHERE main.userID = " + userid + ";";
    database.query(sqlQuery).then(rows => res.send(rows))
})
app.get("/test/", (req, res) => {
    res.send("Being testing")
})

const PORT = process.env.PORT || 9000;
app.listen(PORT, () => console.log(`listening on ${PORT}`));

var table;
var firebaseConfig = {
    apiKey: "AIzaSyAKvgDW_qfVYt-2lxY5vvwbPowiwbwxq28",
    authDomain: "fridge-inv.firebaseapp.com",
    databaseURL: "https://fridge-inv.firebaseio.com",
    projectId: "fridge-inv",
    storageBucket: "fridge-inv.appspot.com",
    messagingSenderId: "562781109229",
    appId: "1:562781109229:web:0d254948fbac567bd745e4",
    measurementId: "G-HZJB389278"
};

firebase.initializeApp(firebaseConfig);
var db = firebase.firestore();

firebase.auth().onAuthStateChanged(function (user) {
    window.user = user;
});

document.querySelector('#sign-in').addEventListener('click', function (e) {
    e.preventDefault();
    e.stopPropagation();
    var email = document.querySelector('#email').value;
    var password = document.querySelector('#password').value
    firebase.auth().signInWithEmailAndPassword(email, password).catch(function (error) {
        // Handle Errors here.
        var errorCode = error.code;
        var errorMessage = error.message;
        console.log(errorCode)
        console.log(errorMessage)
        // ...
    });

});

document.querySelector('#sign-out').addEventListener('click', function (e) {
    e.preventDefault();
    e.stopPropagation();
    firebase.auth().signOut();
});

function checkUser() {
    var auth = firebase.auth().currentUser;
    console.log(auth.uid)

    var url = "http://localhost:9000/all/" + auth.uid
    fetch(url)
        .then(response => response.json())
        .then(json => {
            console.log(json)
            table(json)
        });

}
function table(tableData) {
    var table = new Tabulator("#example-table", {
        height: 300,
        data: tableData,
        layout: "fitColumns",
        columns: [
            { title: "Name", field: "pName", },
            { title: "Price", field: "price" },
            { title: "Barcode", field: "barcode" },
            { title: "Total", field: "total" },
            { title: "Entry Time", field: "entryTime" },
        ],
        rowClick: function (e, row) {
            row.toggleSelect();
        },
    });
}

function check() {

    firebase.auth().onAuthStateChanged(function (user) {
        if (user) {
            var barcode = document.getElementById("Barcode").value
            console.log(barcode)
            var url = "http://localhost:9000/check/" + barcode;
            fetch(url).then(response => {
                response.text().then(function (text) {
                    console.log(text)
                    if (text == 'true') {
                        var auth = firebase.auth().currentUser;
                        console.log(auth.uid)
                        var date = new Date();
                        var newDate = date.toISOString().slice(0, 19).replace('T', ' ');
                        postData('http://localhost:9000/entry', {
                            check: false,
                            userid: auth.uid,
                            barcode: barcode,
                            date: newDate

                        })
                            .then(data => {
                                console.log(data);
                                checkUser()
                            });

                    }
                    if (text == 'false') {
                        if (document.getElementById("name").disabled == false) {
                            var nameI = document.getElementById("name").value;
                            var priceI = document.getElementById("price").value;
                            console.log(nameI)
                            console.log(priceI)
                            var auth = firebase.auth().currentUser;
                            console.log(auth.uid)
                            var date = new Date();
                            var newDate = date.toISOString().slice(0, 19).replace('T', ' ');
                            postData('http://localhost:9000/entry', {
                                check: true,
                                userid: auth.uid,
                                barcode: barcode,
                                date: newDate,
                                name: nameI,
                                price: priceI

                            })
                                .then(data => {
                                    console.log(data);
                                    checkUser()
                                    document.getElementById("name").disabled = true;
                                    document.getElementById("price").disabled = true;
                                    document.getElementById("name").value = "";
                                    document.getElementById("price").value = "";

                                });
                        }
                        else {
                            console.log("Havent Checked barcode yet")
                            document.getElementById("name").disabled = false;
                            document.getElementById("price").disabled = false;
                            console.log("Please enter values")
                        }

                    }
                })
            })
        } else {
            // No user is signed in.
        }
    });
}

function enterProduct() {
    if (document.getElementById("name").disabled == false) {
        var name = document.getElementById("name").value;
        var price = document.getElementById("price").value;
        console.log(name)
        console.log(price)
    }
    else {
        console.log("Havent Checked barcode yet")
    }
}
async function postData(url = '', data = {}) {
    const response = await fetch(url, {
        method: 'POST',
        mode: 'cors',
        headers: {
            'Access-Control-Allow-Origin': '*',
            'Accept': 'application/json',
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(data)
    });
    return response.status;
}
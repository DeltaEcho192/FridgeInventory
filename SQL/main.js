
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

    var url = "http://localhost:9000/all/12345"
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


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
    var tableData = []
    table = new Tabulator("#example-table", {
        height: 300, // set height of table (in CSS or here), this enables the Virtual DOM and improves render speed dramatically (can be any valid css height value)
        data: tableData, //assign data to table
        layout: "fitColumns", //fit columns to width of table (optional)
        columns: [ //Define Table Columns
            { title: "Name", field: "Name", width: 150 },
            { title: "Total", field: "Total" },
            { title: "Price Total", field: "Calc" },

        ],
        rowClick: function (e, row) { //trigger an alert message when the row is clicked
            row.toggleSelect();
        },
    });

    db.collection("Products").where("userID", "==", auth.uid)
        .get()
        .then(function (querySnapshot) {
            querySnapshot.forEach(function (doc) {
                // doc.data() is never undefined for query doc snapshots
                console.log(doc.id, " => ", doc.data());
                var data = doc.data()
                console.log(data.Name)
                console.log(data.Total)
                var calculation = data.Price * data.Total
                console.log(calculation)
                table.addData([{ "Name": data.Name, "Total": data.Total, "Calc": calculation }])
            });
        })
        .catch(function (error) {
            console.log("Error getting documents: ", error);
        });
}

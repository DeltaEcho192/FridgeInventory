import 'dart:async';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import "check.dart";

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String barcode = "";
  Future<Check> _barcodeCheck;

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Barcode Scanner'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Container(
                child: RaisedButton(
                  onPressed: barcodeScanning,
                  child: Text(
                    "Capture Image",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  color: Colors.green,
                ),
                padding: const EdgeInsets.all(10.0),
                margin: EdgeInsets.all(10),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
              ),
              Text(
                "Scanned Barcode Number",
                style: TextStyle(fontSize: 20),
              ),
              Text(
                barcode,
                style: TextStyle(fontSize: 25, color: Colors.green),
              ),
              RaisedButton(
                child: Text("Check Barcode"),
                onPressed: () {
                  setState(() {
                    _barcodeCheck = checkBarcode();
                  });
                },
              ),
              FutureBuilder<Check>(
                future: _barcodeCheck,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    print("The Data " + snapshot.data.check.toString());
                    return Text("Testing");
                  } else if (snapshot.hasError) {
                    print(snapshot.error);
                    return Text("${snapshot.error}");
                  }
                  return CircularProgressIndicator();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  //scan barcode asynchronously
  Future barcodeScanning() async {
    try {
      var barcode = await BarcodeScanner.scan();
      var response = checkBarcode();
      print(response);
      setState(() => this.barcode = barcode.rawContent.toString());
    } on PlatformException catch (e) {
      print(e);
    } on FormatException {
      setState(() => this.barcode = 'Nothing captured.');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }
}

Future<Check> checkBarcode() async {
  final response = await http.get('http://10.0.0.102:8000/checkTest.json');
  if (response.statusCode == 200) {
    return Check.fromJson(json.decode(response.body)[0]);
  } else {
    throw Exception("Unable to access Server.");
  }
}

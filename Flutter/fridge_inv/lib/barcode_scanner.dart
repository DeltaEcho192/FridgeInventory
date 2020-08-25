import 'dart:async';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  String barcode = "";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text('Barcode Scanner - googleflutter.com'),
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
              ],
            ),
          )),
    );
  }

  //scan barcode asynchronously
  Future barcodeScanning() async {
    try {
      var barcode = await BarcodeScanner.scan();
      print(barcode);
      this.barcode = barcode.toString();
    } on PlatformException catch (e) {
      this.barcode = 'Unknown error: $e';
    } on FormatException {
      this.barcode = 'Nothing captured.';
    } catch (e) {
      this.barcode = 'Unknown error: $e';
    }
  }
}

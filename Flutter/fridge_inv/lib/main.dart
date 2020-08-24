import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'Product.dart';
import 'Total.dart';

void main() => runApp(MyApp(
      products: fetchProducts(),
      total: fetchTotal(),
    ));

List<Product> parseProducts(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Product>((json) => Product.fromJson(json)).toList();
}

Future<List<Product>> fetchProducts() async {
  final response =
      await http.get('http://10.0.0.102:9000/all/aF63z0R0jlQR7sfOgBAgOCOsQgv1');
  if (response.statusCode == 200) {
    return parseProducts(response.body);
  } else {
    throw Exception("Unable to access Server.");
  }
}

class MyApp extends StatelessWidget {
  final Future<List<Product>> products;
  final Future<List<Total>> total;
  MyApp({Key key, this.products, this.total}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        title: 'Product Navigation demo home page',
        products: products,
        total: total,
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;
  final Future<List<Product>> products;
  final Future<List<Total>> total;
  MyHomePage({Key key, this.title, this.products, this.total})
      : super(key: key);

  // final items = Product.getProducts();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Product Navigation")),
      body: Center(
        child: FutureBuilder<List<Product>>(
          future: products,
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            return snapshot.hasData
                ? ProductBoxList(items: snapshot.data)

                // return the ListView widget :
                : Center(child: CircularProgressIndicator());
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TotalPage(
                        total: total,
                      )));
        },
        child: Icon(Icons.navigation),
        backgroundColor: Colors.green,
      ),
    );
  }
}

class ProductBoxList extends StatelessWidget {
  final List<Product> items;
  ProductBoxList({Key key, this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          child: ProductBox(item: items[index]),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductPage(item: items[index]),
              ),
            );
          },
        );
      },
    );
  }
}

class ProductPage extends StatelessWidget {
  ProductPage({Key key, this.item}) : super(key: key);
  final Product item;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.item.pName),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                    child: Container(
                        padding: EdgeInsets.all(5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(this.item.pName,
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text("Price: " + this.item.price),
                            Text("Barcode: " + this.item.barcode.toString()),
                          ],
                        )))
              ]),
        ),
      ),
    );
  }
}

class ProductBox extends StatelessWidget {
  ProductBox({Key key, this.item}) : super(key: key);
  final Product item;

  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(2),
        height: 140,
        child: Card(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                    child: Container(
                        padding: EdgeInsets.all(5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(this.item.pName,
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text("Price: " + this.item.price),
                            Text("Barcode: " + this.item.barcode.toString()),
                          ],
                        )))
              ]),
        ));
  }
}

List<Total> parseTotal(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Total>((json) => Total.fromJson(json)).toList();
}

Future<List<Total>> fetchTotal() async {
  final response = await http.get('http://10.0.0.102:8000/testData.json');
  if (response.statusCode == 200) {
    return parseTotal(response.body);
  } else {
    throw Exception("Unable to access Server.");
  }
}

class TotalPage extends StatelessWidget {
  final String title;
  final Future<List<Total>> total;

  TotalPage({Key key, this.title, this.total}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Product Navigation")),
      body: Center(
        child: FutureBuilder<List<Total>>(
          future: total,
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            print(snapshot.data);
            return snapshot.hasData
                ? TotalBoxList(items: snapshot.data)

                // return the ListView widget :
                : Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

class TotalBoxList extends StatelessWidget {
  final List<Total> items;
  TotalBoxList({Key key, this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          child: TotalDisplay(item: items[index]),
        );
      },
    );
  }
}

class TotalDisplay extends StatelessWidget {
  TotalDisplay({Key key, this.item}) : super(key: key);
  final Total item;

  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(2),
        height: 140,
        child: Card(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                    child: Container(
                        padding: EdgeInsets.all(5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(this.item.total.toString(),
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        )))
              ]),
        ));
  }
}

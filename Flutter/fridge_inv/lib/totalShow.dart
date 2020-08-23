import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'Total.dart';

void main() => runApp(MyApp(
      total: fetchProducts(),
    ));

List<Total> parseTotal(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Total>((json) => Total.fromJson(json)).toList();
}

Future<List<Total>> fetchProducts() async {
  final response = await http.get('http://10.0.0.102:8000/testData.json');
  if (response.statusCode == 200) {
    return parseTotal(response.body);
  } else {
    throw Exception("Unable to access Server.");
  }
}

class MyApp extends StatelessWidget {
  final String title;
  final Future<List<Total>> total;
  MyApp({Key key, this.title, this.total}) : super(key: key);

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
        total: total,
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;
  final Future<List<Total>> total;
  MyHomePage({Key key, this.title, this.total}) : super(key: key);

  // final items = Product.getProducts();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Product Navigation")),
      body: Center(
        child: FutureBuilder<List<Total>>(
          future: total,
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            return snapshot.hasData
                ? ProductBoxList(items: snapshot.data)

                // return the ListView widget :
                : Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

class ProductBoxList extends StatelessWidget {
  final List<Total> items;
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
  final Total item;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.item.total.toString()),
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
                            Text(this.item.total.toString(),
                                style: TextStyle(fontWeight: FontWeight.bold)),
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

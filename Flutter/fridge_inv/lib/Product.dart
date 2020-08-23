import 'package:flutter/foundation.dart';

class Product {
  final String pName;
  final String price;
  final int barcode;
  final int total;

  Product(this.pName, this.price, this.barcode, this.total);
  factory Product.fromJson(Map<String, dynamic> data) {
    return Product(
      data['pName'],
      data['price'],
      data['barcode'],
      data['total'],
    );
  }
}

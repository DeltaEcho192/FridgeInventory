import 'package:flutter/foundation.dart';

class Total {
  final double total;

  Total(this.total);
  factory Total.fromJson(Map<String, dynamic> data) {
    return Total(
      data['total'],
    );
  }
}

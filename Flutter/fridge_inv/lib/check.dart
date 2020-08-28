import 'package:flutter/foundation.dart';

class Check {
  final String check;

  Check({this.check});
  factory Check.fromJson(Map<String, dynamic> data) {
    return Check(
      check: data['Check'],
    );
  }
}

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/msq_item.dart';

class MsqLoader {
  static Future<MsqSchema> loadFromAsset(String path) async {
    final raw = await rootBundle.loadString(path);
    final map = json.decode(raw) as Map<String, dynamic>;
    return MsqSchema.fromMap(map);
  }
}

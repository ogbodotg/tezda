import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ApiData {
  Future saveJsonData(jsonData, key) async {
    final prefs = await SharedPreferences.getInstance();
    var saveData = jsonEncode(jsonData);
    await prefs.setString('$key', saveData);
  }

  Future removeJsonData(key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$key');
  }
}

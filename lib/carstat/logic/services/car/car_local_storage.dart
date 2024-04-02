import 'dart:convert';
import 'package:my_project/carstat/logic/models/car.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CarLocalStorage {
  static const _carDataKey = 'carData';

  Future<void> post(Car data) async {
    final prefs = await SharedPreferences.getInstance();
    final List<Car> dataList = await getAll();

    dataList.add(data);
    final List<String> jsonDataList =
        dataList.map((data) => jsonEncode(data.toJson())).toList();
    await prefs.setStringList(_carDataKey, jsonDataList);
  }

  Future<List<Car>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? jsonDataList = prefs.getStringList(_carDataKey);

    if (jsonDataList == null) return [];
    return jsonDataList
        .map((jsonData) =>
            Car.fromJson(jsonDecode(jsonData) as Map<String, dynamic>),)
        .toList();
  }

  Future<void> delete(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final List<Car> dataList = await getAll();
    dataList.removeWhere((data) => data.id == id);

    final List<String> jsonDataList =
        dataList.map((data) => jsonEncode(data.toJson())).toList();
    await prefs.setStringList(_carDataKey, jsonDataList);
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_carDataKey);
  }
}

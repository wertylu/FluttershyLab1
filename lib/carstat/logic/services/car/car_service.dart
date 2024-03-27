import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:my_project/carstat/logic/models/car.dart';
import 'package:my_project/carstat/logic/services/car/car_local_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ICarService {
  Future<List<Car>> loadCarList();
  Future<void> saveCarList(List<Car> dataList);
  Future<void> addCar(Car data);
  Future<void> deleteCar(int index);
}


class CarService implements ICarService{
  static const String baseUrl = 'http://10.0.2.2:8080/api/car_data';
  static const _carKey = 'carKey';
  CarLocalStorage carLocalStorage= CarLocalStorage();



  @override
  Future<List<Car>> loadCarList() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return carLocalStorage.getAll();
    } else {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedResponse =
        jsonDecode(response.body) as Map<String, dynamic>;

        if (decodedResponse['_embedded'] != null &&
            decodedResponse['_embedded']['car_datas'] != null) {
          final List<dynamic> carDatas =
          decodedResponse['_embedded']['car_datas'] as List<dynamic>;
          final List<Car> carList = carDatas
              .map((dynamic item) =>
              Car.fromJson(item as Map<String, dynamic>),)
              .toList();

          await carLocalStorage.clearAll();
          for (var data in carList) {
            await carLocalStorage.post(data);
          }

          return carList;
        } else {
          return [];
        }
      } else {
        throw Exception('Failed to load fitness data from API');
      }
    }
  }

  @override
  Future<void> saveCarList(List<Car> dataList) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_carKey,
      jsonEncode(dataList.map((data) => data.toJson()).toList()),);
  }

  @override
  Future<void> addCar(Car data) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      throw Exception('No internet connection. Cannot add data.');
    } else {
      final response = await http.post(
        Uri.parse('$baseUrl/create'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data.toJson()),
      );

      if (response.statusCode == 200) {
        await carLocalStorage.post(data);
      } else {
        throw Exception('Failed to add fitness data to API');
      }
    }
  }

  @override
  Future<void> deleteCar(int carId) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      throw Exception('No internet connection. Cannot delete data.');
    } else {
      final response =
      await http.delete(Uri.parse('$baseUrl/delete/$carId'));
      if (response.statusCode == 200) {
        await carLocalStorage.delete(carId);
      } else {
        throw Exception('Failed to delete fitness data from API');
      }
    }
  }
}
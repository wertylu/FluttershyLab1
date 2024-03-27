import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:my_project/carstat/logic/models/user.dart';
import 'package:my_project/carstat/logic/services/authentication/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class IAuthService {
  Future<String?> register(String name, String email, String password);
  Future<void> logout();
  Future<bool> login(String email, String password);
}

class AuthService implements IAuthService {
  final UserService _userService = UserService();
  final String _baseUrl = 'http://10.0.2.2:8080/api/users';

  @override
  Future<String?> register(String name, String email, String password) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return 'No internet connection. '
          'Please connect to the internet to sign up.';
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/create'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final newUser = User(name: name, email: email, password: password);
      await _userService.saveUser(newUser);
      return null;
    } else {
      return 'Failed to register user';
    }
  }

  @override
  Future<bool> login(String email, String password) async {

    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {

      final Uri fetchUserUri = Uri.parse('$_baseUrl/email/$email');

      try {
        final response = await http.get(fetchUserUri);
        if (response.statusCode == 200) {
          final body = jsonDecode(response.body);
          final userMap = (body as List).first as Map<String, dynamic>;
          if (password == userMap['password']) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('currentUser', email);
            return true;
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error fetching user from backend: $e');
        }
      }
    }
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString(email);
    if (userString != null) {
      final userMap = jsonDecode(userString) as Map<String, dynamic>;
      if (password == userMap['password']) {
        await prefs.setString('currentUser', email);
        return true;
      }
    }
    return false;
  }
  @override
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('currentUser');
  }
}

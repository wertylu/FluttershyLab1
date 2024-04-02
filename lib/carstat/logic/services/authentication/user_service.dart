import 'dart:convert';

import 'package:my_project/carstat/logic/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class IUserService {
  Future<void> saveUser(User user);
}

class UserService implements IUserService {
  @override
  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(user.email, jsonEncode(user.toJson()));
  }
}

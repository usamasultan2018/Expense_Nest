import 'dart:convert';
import 'package:expense_tracker/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static SharedPreferences? preferences;

  static const String _userKey = 'user';

  // Initialize SharedPreferences
  static Future<void> initialize() async {
    preferences = await SharedPreferences.getInstance();
  }

  // Save UserModel (user ID)
  static Future<void> saveUser(UserModel user) async {
    String userJson = json.encode(user.toJson());
    await preferences?.setString(_userKey, userJson);
  }

  // Retrieve UserModel (user ID)
  static UserModel? getUser() {
    String? userJson = preferences?.getString(_userKey);
    if (userJson != null) {
      Map<String, dynamic> userMap = json.decode(userJson);
      return UserModel.fromJson(userMap);
    }
    return null;
  }

  // Remove UserModel
  static Future<void> removeUser() async {
    await preferences?.remove(_userKey);
  }

  // Check if a user is saved
  static bool hasUser() {
    return preferences?.containsKey(_userKey) ?? false;
  }
}

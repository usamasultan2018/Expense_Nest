import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class HTrackerSharedPreferences {
  static SharedPreferences? preferences;

  static Future<void> getInit() async {
    preferences = await SharedPreferences.getInstance();
  }

  // Get a string from SharedPreferences.
  static String? getString(String key) {
    return preferences?.getString(key);
  }

  // Set a string in SharedPreferences.
  static Future<void> setString(String key, String value) async {
    await preferences?.setString(key, value);
  }

  // Get a string from SharedPreferences.
  static List<String>? getStringList(String key) {
    return preferences?.getStringList(key);
  }

  // Set a string in SharedPreferences.
  static Future<void> setStringList(String key, List<String> value) async {
    await preferences?.setStringList(key, value);
  }

  // Get a Double from SharedPreferences.
  static double? getDouble(String key) {
    return preferences?.getDouble(key);
  }

  // Set a Double in SharedPreferences.
  static Future<void> setDouble(String key, double value) async {
    await preferences?.setDouble(key, value);
  }

  // Get a bool from SharedPreferences.
  static bool? getBool(String key) {
    return preferences?.getBool(key);
  }

  // Set a bool in SharedPreferences.
  static Future<void> setBool(String key, bool value) async {
    await preferences?.setBool(key, value);
  }

  static bool containsKey(String key) {
    return preferences?.containsKey(key) ?? false;
  }

  static Future<void> removeKey(String key) async {
    await preferences?.remove(key);
  }

  static Future<void> addMapToSharedPreferences(
      String key, Map<String, dynamic> newData) async {
    List<String>? existingData = preferences?.getStringList(key);
    List<String> updatedData = existingData ?? [];
    updatedData.add(json.encode(newData));
    await preferences?.setStringList(key, updatedData);
  }

  static Future<void> addToSharedPreferencesMap(
      String key, Map<String, dynamic> newData) async {
    List<String>? existingData = preferences?.getStringList(key);
    List<String> updatedData = existingData ?? [];
    updatedData.add(json.encode(newData));
    await preferences?.setStringList(key, updatedData);
  }

  static List<Map<String, dynamic>> getListOfMaps(String key) {
    List<String>? jsonStringList = preferences?.getStringList(key);
    if (jsonStringList != null) {
      List<Map<String, dynamic>> listOfMaps = jsonStringList
          .map((jsonString) => json.decode(jsonString))
          .cast<Map<String, dynamic>>()
          .toList();
      return listOfMaps;
    } else {
      return [];
    }
  }

  // Function to update the list of maps in SharedPreferences
  static Future<void> updateListOfMaps(
      String key, List<Map<String, dynamic>> newData) async {
    List<String> jsonStringList =
        newData.map((data) => json.encode(data)).toList();
    await preferences?.setStringList(key, jsonStringList);
  }
}

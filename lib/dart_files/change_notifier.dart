import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String _username = '';

  String get username => _username;

  // Initialize Hive box and get the stored username
  Future<void> initializeUser() async {
    var box = await Hive.openBox('myBox');
    _username = box.get('username', defaultValue: '') ?? '';
    notifyListeners();
  }

  // Set the username, save it in Hive, and notify listeners
  Future<void> setUsername(String newUsername) async {
    var box = await Hive.openBox('myBox');

    // Clear previous username first
    await box.delete('username');

    _username = newUsername;
    await box.put('username', newUsername); // Store the new username in Hive
    notifyListeners();
  }

  // Clear the username from Hive and reset locally
  Future<void> clearUsernameFromHive() async {
    var box = await Hive.openBox('myBox');
    await box.delete('username');
    _username = '';
    notifyListeners();
  }
}

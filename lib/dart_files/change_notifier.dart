import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String _username = "User";

  String get username => _username;

  void setUsername(String newUsername) {
    _username = newUsername;
    notifyListeners(); // Notify all listeners about the change
  }
}

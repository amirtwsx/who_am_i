import 'package:flutter/material.dart';
import 'user_model.dart';

class AuthProvider extends ChangeNotifier {
  AppUser? _user;

  AppUser? get user => _user;
  bool get isLoggedIn => _user != null;

  void login(String email) {
    _user = AppUser(email: email);
    notifyListeners();
  }

  void logout() {
    _user = null;
    notifyListeners();
  }

  void updateUsername(String name) {
    if (_user != null) {
      _user!.username = name;
      notifyListeners();
    }
  }
}

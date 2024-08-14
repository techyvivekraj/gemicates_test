import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../controllers/auth_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;
  final AuthController _authController = AuthController();
  String? _uid;

  UserProvider() {
    _loadUid();
  }

  Future<void> _loadUid() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _uid = preferences.getString("uid");
    notifyListeners();
  }

  String? get user => _uid;

  Future<void> signIn(String email, String password) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      _user = await _authController.signIn(email, password);
      preferences.setString("uid", _user!.uid.toString());
      notifyListeners();
    } catch (e) {
      throw Exception('Sign-in failed: $e');
    }
  }

  Future<void> signUp(String name, String email, String password) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      _user = await _authController.signUp(name, email, password);
      preferences.setString("uid", _user!.uid.toString());
      notifyListeners();
    } catch (e) {
      throw Exception('Sign-up failed: $e');
    }
  }

  void signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _authController.signOut();
    _user = null;
    preferences.clear();
    notifyListeners();
  }
}

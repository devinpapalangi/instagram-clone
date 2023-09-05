import 'package:flutter/material.dart';
import 'package:instagram_clone/features/auth/services/auth_services.dart';
import 'package:instagram_clone/models/user.dart';

class UserProvider extends ChangeNotifier {
  User? _user;
  final AuthServices _authServices = AuthServices();

  User get getUser => _user!;

  Future<void> refreshUser() async {
    User user = await _authServices.getUserDetails();
    _user = user;

    notifyListeners();
  }
}

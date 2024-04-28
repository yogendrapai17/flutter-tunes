import 'package:flutter/material.dart';
import 'package:flutter_tunes/common/models/user.dart';
import 'package:flutter_tunes/services/user_service.dart';

import 'login_status.dart';

class LoginProvider extends ChangeNotifier {
  /// Login Page status
  LoginStatus? loginStatus;

  /// If user details available
  User? existingUser;

  Future<void> initialize() async {
    loginStatus = LoginStatus.unknown;
  }

  /// Check if user exists in database
  Future<void> checkUserExists({required String email}) async {
    final ifExists = await _userService.checkUserExists(email: email);

    if (ifExists != null) {
      existingUser = ifExists;
      loginStatus = LoginStatus.unauthenticated;
    } else {
      loginStatus = LoginStatus.newUser;
    }
    notifyListeners();
  }

  Future<User?> signUpUser(
      {required String name,
      required String email,
      required String password}) async {
    try {
      final user = User(
          userId: DateTime.now().millisecondsSinceEpoch.toString(),
          name: name,
          email: email,
          password: password);

      final result = await _userService.signUpUser(user: user);

      if (result ?? false) return user;
    } catch (e) {
      debugPrint("Sign Up error: ${e.toString()}");
    }

    return null;
  }

  /// Check if the login details are correct
  bool verifyLogin({required String password}) =>
      existingUser?.password == password;

  UserService get _userService => UserService();
}

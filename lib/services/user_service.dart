import 'package:flutter/material.dart';
import 'package:flutter_tunes/common/models/user.dart';
import 'package:flutter_tunes/services/firebase_service.dart';

class UserService {
  /// With an email check if user exists
  Future<User?> checkUserExists({required String email}) async {
    try {
      final response = await fbService.getDocumentsByField(
          collectionPath: 'users', fieldName: 'email', value: email);

      if (response?.docs != null && (response?.docs.isNotEmpty ?? true)) {
        final data = response!.docs.first.data();

        return User.fromJson(data);
      }
    } catch (e) {
      debugPrint("User exists API error: ${e.toString()}");
    }
    return null;
  }

  /// Fetch user details by user ID
  Future<User?> getUserDetails({required String userId}) async {
    try {
      final response = await fbService.getDocumentsByField(
          collectionPath: 'users', fieldName: 'user_id', value: userId);

      if (response?.docs != null && (response?.docs.isNotEmpty ?? true)) {
        final data = response!.docs.first.data();

        return User.fromJson(data);
      }
    } catch (e) {
      debugPrint("User exists API error: ${e.toString()}");
    }
    return null;
  }

  /// Update user details or favourite data
  Future<bool?> updateUserDetails({required User userData}) async =>
      await fbService.updateDocument(
          'users', userData.userId, userData.toJson());

  /// Sign Up a new user
  Future<bool?> signUpUser({required User user}) async {
    try {
      await fbService.createDocument(
          collectionPath: 'users',
          documentId: user.userId,
          data: user.toJson());

      return true;
    } catch (e) {
      debugPrint("User exists API error: ${e.toString()}");
    }

    return false;
  }

  FirebaseService get fbService => FirebaseService.instance;
}

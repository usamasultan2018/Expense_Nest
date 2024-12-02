import 'dart:io';

import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/models/user.dart';

abstract class IUserRepository {
  // Get user data by user ID
  Future<UserModel?> getUserData(String uid);

  // Stream user data by user ID
  Stream<UserModel?> streamUserData(String uid);

  // Update user data
  Future<void> updateUserData(UserModel userModel);

  // Delete user data
  Future<void> deleteUserData(String uid);

  // Upload profile picture to Firebase Storage
  Future<String?> uploadProfilePicture(File imageFile, String userId);

  // Stream account data for a user
  Stream<AccountModel?> streamAccount(String userId);

  // Logout function
  Future<void> logout();
}

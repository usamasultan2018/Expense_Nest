import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/core/models/account.dart';
import 'package:expense_tracker/core/models/user.dart';
import 'package:expense_tracker/core/repository/base/i_user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class UserRepository implements IUserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance; // Initialize FirebaseAuth

  // Get user data
  @override
  Future<UserModel?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromJson(doc.data() as Map<String, dynamic>);
      } else {
        print('User not found');
        return null;
      }
    } catch (e) {
      print('Error fetching user data: $e');
      rethrow; // Handle the exception as necessary
    }
  }

  // Stream user data
  @override
  Stream<UserModel?> streamUserData(String uid) {
    return _firestore.collection('users').doc(uid).snapshots().map((snapshot) {
      if (snapshot.exists) {
        return UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
      } else {
        return null; // Return null if user does not exist
      }
    });
  }

  // Update user data
  @override
  Future<void> updateUserData(UserModel userModel) async {
    try {
      await _firestore
          .collection('users')
          .doc(userModel.id)
          .update(userModel.toJson());
      print('User data updated successfully for ${userModel.email}');
    } catch (e) {
      print('Error updating user data: $e');
      rethrow; // Handle the exception as necessary
    }
  }

  // Delete user data
  @override
  Future<void> deleteUserData(String uid) async {
    try {
      // Delete user document
      await _firestore.collection('users').doc(uid).delete();

      // Delete account document
      await _firestore.collection('accounts').doc(uid).delete();

      // Delete transactions
      final transactions = await _firestore
          .collection('transactions')
          .where('userId', isEqualTo: uid)
          .get();

      for (final doc in transactions.docs) {
        await doc.reference.delete();
      }

      print(
          'User data, account, and transactions deleted successfully for UID: $uid');
    } catch (e) {
      print('Error deleting user data: $e');
      rethrow; // Handle the exception as necessary
    }
  }

  // Upload profile picture to Firebase Storage
  @override
  Future<String?> uploadProfilePicture(File imageFile, String userId) async {
    try {
      String filePath =
          "profile_pics/$userId/${DateTime.now().millisecondsSinceEpoch}.png";

      UploadTask uploadTask = _storage.ref().child(filePath).putFile(imageFile);

      TaskSnapshot taskSnapshot = await uploadTask;

      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("Error uploading profile picture: $e");
      return null; // Return null if error occurs
    }
  }

  // Get Account data for user
  @override
  Future<AccountModel?> getAccountData(String userId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('accounts').doc(userId).get();
      if (doc.exists) {
        return AccountModel.fromFirestore(doc);
      } else {
        print('Account not found for userId: $userId');
        return null;
      }
    } catch (e) {
      print('Error fetching account: $e');
      return null; // Handle error
    }
  }

  // Stream Account data for user
  @override
  Stream<AccountModel?> streamAccount(String userId) {
    return _firestore.collection('accounts').doc(userId).snapshots().map((doc) {
      if (doc.exists) {
        return AccountModel.fromFirestore(doc);
      } else {
        print('Account not found for userId: $userId');
        return null; // Return null if the document doesn't exist
      }
    }).handleError((error) {
      print('Error fetching account: $error');
      return null; // Handle error
    });
  }

  Future<Map<String, int>> getTransactionCounts(
    String userId,
  ) async {
    try {
      final transactions = await _firestore
          .collection('transactions')
          .where('userId', isEqualTo: userId)
          .get();

      int incomeCount = 0;
      int expenseCount = 0;

      for (final doc in transactions.docs) {
        final data = doc.data();

        if (data['type'] == 'income') {
          incomeCount++;
        } else if (data['type'] == 'expense') {
          expenseCount++;
        }
      }

      return {
        'income': incomeCount,
        'expense': expenseCount,
      };
    } catch (e) {
      debugPrint(
        'Error fetching transaction counts: $e',
      );

      return {
        'income': 0,
        'expense': 0,
      };
    }
  }

  // Logout function
  @override
  Future<void> logout() async {
    try {
      await _auth.signOut();
      print('User logged out successfully');
    } catch (e) {
      print('Error logging out: $e');
      rethrow; // Handle error during logout
    }
  }
}

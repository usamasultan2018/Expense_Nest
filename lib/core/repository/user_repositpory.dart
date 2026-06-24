import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/core/models/account.dart';
import 'package:expense_tracker/core/models/user.dart';
import 'package:expense_tracker/core/repository/base/i_user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class UserRepository implements IUserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Get user data
  @override
  Future<UserModel?> getUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromJson(doc.data() as Map<String, dynamic>);
      }
      debugPrint('User not found: $uid');
      return null;
    } catch (e) {
      debugPrint('Error fetching user data: $e');
      rethrow;
    }
  }

  /// Stream user data — widgets using this will react to webhook updates live
  @override
  Stream<UserModel?> streamUserData(String uid) {
    return _firestore.collection('users').doc(uid).snapshots().map((snapshot) {
      if (snapshot.exists) {
        return UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
      }
      return null;
    });
  }

  /// Profile update — never touches isPremium or subscriptionStatus
  @override
  Future<void> updateUserData(UserModel userModel) async {
    try {
      await _firestore
          .collection('users')
          .doc(userModel.id)
          .set(
            userModel.toProfileUpdateMap(),
            SetOptions(merge: true), // webhook fields are never overwritten
          );
      debugPrint('Profile updated for ${userModel.email}');
    } catch (e) {
      debugPrint('Error updating user data: $e');
      rethrow;
    }
  }

  /// Delete user data + account + transactions
  @override
  Future<void> deleteUserData(String uid) async {
    try {
      await _firestore.collection('users').doc(uid).delete();
      await _firestore.collection('accounts').doc(uid).delete();

      final transactions = await _firestore
          .collection('transactions')
          .where('userId', isEqualTo: uid)
          .get();

      for (final doc in transactions.docs) {
        await doc.reference.delete();
      }

      debugPrint('User data deleted for UID: $uid');
    } catch (e) {
      debugPrint('Error deleting user data: $e');
      rethrow;
    }
  }

  /// Upload profile picture to Firebase Storage
  @override
  Future<String?> uploadProfilePicture(File imageFile, String userId) async {
    try {
      final filePath =
          'profile_pics/$userId/${DateTime.now().millisecondsSinceEpoch}.png';

      final uploadTask = _storage.ref().child(filePath).putFile(imageFile);
      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      debugPrint('Error uploading profile picture: $e');
      return null;
    }
  }

  /// Get account data
  @override
  Future<AccountModel?> getAccountData(String userId) async {
    try {
      final doc =
          await _firestore.collection('accounts').doc(userId).get();
      if (doc.exists) {
        return AccountModel.fromFirestore(doc);
      }
      debugPrint('Account not found for userId: $userId');
      return null;
    } catch (e) {
      debugPrint('Error fetching account: $e');
      return null;
    }
  }

  /// Stream account data
  @override
  Stream<AccountModel?> streamAccount(String userId) {
    return _firestore
        .collection('accounts')
        .doc(userId)
        .snapshots()
        .map((doc) {
      if (doc.exists) {
        return AccountModel.fromFirestore(doc);
      }
      return null;
    }).handleError((error) {
      debugPrint('Error streaming account: $error');
      return null;
    });
  }

  /// Get income/expense transaction counts
  Future<Map<String, int>> getTransactionCounts(String userId) async {
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

      return {'income': incomeCount, 'expense': expenseCount};
    } catch (e) {
      debugPrint('Error fetching transaction counts: $e');
      return {'income': 0, 'expense': 0};
    }
  }

  /// Logout
  @override
  Future<void> logout() async {
    try {
      await _auth.signOut();
      debugPrint('User logged out successfully');
    } catch (e) {
      debugPrint('Error logging out: $e');
      rethrow;
    }
  }
}
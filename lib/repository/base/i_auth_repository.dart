import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

abstract class IAuthRepository {
  Future<User?> signUpWithGoogle();
  Future<User?> signUp(String email, String password, String username);
  Future<User?> signIn(String email, String password);
  Future<void> signOut();
  Future<void> deleteAccount(BuildContext context);
  User? getCurrentUser();
}

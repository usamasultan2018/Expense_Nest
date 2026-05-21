import 'package:firebase_auth/firebase_auth.dart';

abstract class IAuthRepository {
  Future<User?> signUpWithGoogle();
  Future<User?> signUp({
    required String email,
    required String password,
    required String username,
  });
  Future<User?> signIn({
    required String email,
    required String password,
  });
  Future<void> signOut();
  Future<void> sendPasswordResetEmail(String email);
  Future<void> sendEmailVerification();
  User? getCurrentUser();
  Stream<User?> get authStateChanges;
}

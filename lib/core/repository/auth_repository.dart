import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/core/models/user.dart';
import 'package:expense_tracker/core/models/account.dart';
import 'package:expense_tracker/core/repository/base/i_auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository implements IAuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;

  AuthRepository({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
    GoogleSignIn? googleSignIn,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  @override
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  @override
  Future<User?> signUpWithGoogle() async {
    try {
      // signout
      _googleSignIn.signOut();
      // Trigger Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // User cancelled the sign-in
      if (googleUser == null) return null;

      // Obtain authentication details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create Firebase credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with Google credential
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        const String fcmToken = "";

        // Initialize user in Firestore (creates user doc if new)
        await _initializeUserInFirestore(
          user,
          fcmToken: fcmToken,
        );

        // Fetch complete user data from Firestore
        await _fetchUserFromFirestore(user.uid);

        // Save to local storage

        debugPrint('✅ Google sign-in successful for user: ${user.uid}');
      }

      return user;
    } on FirebaseAuthException catch (e) {
      debugPrint('❌ Firebase Auth Error (Google): ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('❌ Error signing up with Google: $e');
      rethrow;
    }
  }

  @override
  Future<User?> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      // Create user with email and password
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;

      if (user != null) {
        // Initialize user in Firestore
        await _initializeUserInFirestore(user, username: username);

        // Fetch complete user data from Firestore
       await _fetchUserFromFirestore(user.uid);

        debugPrint('✅ Email sign-up successful for user: ${user.uid}');
      }

      return user;
    } on FirebaseAuthException catch (e) {
      debugPrint('❌ Firebase Auth Error (Sign Up): ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('❌ Error signing up: $e');
      rethrow;
    }
  }

  @override
  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      // Sign in with email and password
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;

      if (user != null) {
        // Fetch complete user data from Firestore
        await _fetchUserFromFirestore(user.uid);

        // Save to local storage

        debugPrint('✅ Sign-in successful for user: ${user.uid}');
      }

      return user;
    } on FirebaseAuthException catch (e) {
      debugPrint('❌ Firebase Auth Error (Sign In): ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('❌ Error signing in: $e');
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      // Sign out from Google
      await _googleSignIn.signOut();

      // Sign out from Firebase
      await _auth.signOut();

      debugPrint('✅ User signed out successfully');
    } catch (e) {
      debugPrint('❌ Error signing out: $e');
      rethrow;
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      debugPrint('✅ Password reset email sent to $email');
    } on FirebaseAuthException catch (e) {
      debugPrint('❌ Firebase Auth Error (Reset): ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('❌ Error sending password reset email: $e');
      rethrow;
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    try {
      final User? user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        debugPrint('✅ Verification email sent to ${user.email}');
      }
    } catch (e) {
      debugPrint('❌ Error sending email verification: $e');
      rethrow;
    }
  }

  @override
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  /// Fetch user data from Firestore
  /// [userId] User's unique identifier
  /// Returns [UserModel] with complete user data
  /// Throws [Exception] if user document doesn't exist
  Future<UserModel> _fetchUserFromFirestore(String userId) async {
    try {
      final DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();

      if (!userDoc.exists) {
        throw Exception('User document not found in Firestore');
      }

      final Map<String, dynamic> userData =
          userDoc.data() as Map<String, dynamic>;

      // Handle both Timestamp and String formats for backwards compatibility
      DateTime createdAtDate;
      final createdAtValue = userData['createdAt'];
      if (createdAtValue is Timestamp) {
        createdAtDate = createdAtValue.toDate();
      } else if (createdAtValue is String) {
        createdAtDate = DateTime.parse(createdAtValue);
      } else {
        createdAtDate = DateTime.now();
      }

      return UserModel(
        id: userId,
        username: userData['username'] ?? '',
        email: userData['email'] ?? '',
        profilePicture: userData['profilePicture'] ?? '',
        createdAt: createdAtDate,
        deviceToken: userData['deviceToken'],
      );
    } catch (e) {
      debugPrint('❌ Error fetching user from Firestore: $e');
      rethrow;
    }
  }

  /// Initialize user and account documents in Firestore
  /// Only creates documents if they don't already exist
  /// [user] Firebase user object
  /// [username] Optional username (defaults to display name)
  /// [fcmToken] Optional FCM device token
  Future<void> _initializeUserInFirestore(
    User user, {
    String username = '',
    String? fcmToken,
  }) async {
    try {
      // Check if user document already exists
      final DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();

      // Only initialize if user doesn't exist
      if (!userDoc.exists) {
        final String displayName =
            username.isNotEmpty ? username : user.displayName ?? 'User';

        // Create user document
        final UserModel userModel = UserModel(
          id: user.uid,
          username: displayName,
          email: user.email ?? '',
          profilePicture: user.photoURL ?? '',
          createdAt: DateTime.now(),
          deviceToken: fcmToken,
        );

        await _firestore
            .collection('users')
            .doc(user.uid)
            .set(userModel.toFirestoreMap());

        // Create default account document
        final AccountModel accountModel = AccountModel(
          userId: user.uid,
          accountName: '$displayName\'s Account',
          balance: 0.0,
          totalIncome: 0.0,
          totalExpense: 0.0,
          createdAt: Timestamp.now(),
        );

        await _firestore
            .collection('accounts')
            .doc(user.uid)
            .set(accountModel.toMap());

        debugPrint('✅ User and account initialized in Firestore: ${user.uid}');
      } else {
        debugPrint('ℹ️ User already exists in Firestore: ${user.uid}');
      }
    } catch (e) {
      debugPrint('❌ Error initializing user in Firestore: $e');
      rethrow;
    }
  }
}

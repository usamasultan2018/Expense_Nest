import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/core/models/user.dart';
import 'package:expense_tracker/core/models/account.dart';
import 'package:expense_tracker/core/repository/base/i_auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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

  // ── FCM Token ─────────────────────────────────────────────────────────────

  /// Fetches the current FCM token and saves it to Firestore for the given user.
  /// Call this on login/signup and whenever the token refreshes.
  Future<void> saveDeviceToken(String userId) async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token == null) return;

      await _firestore.collection('users').doc(userId).update({
        'deviceToken': token,
      });

      debugPrint('✅ FCM token saved for user: $userId');
    } catch (e) {
      debugPrint('⚠️ Could not save FCM token: $e');
      // Non-fatal — don't rethrow
    }
  }

  @override
  Future<User?> signUpWithGoogle() async {
    try {
      _googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        // Get real FCM token
        final String? fcmToken = await FirebaseMessaging.instance.getToken();

        await _initializeUserInFirestore(user, fcmToken: fcmToken);
        await _fetchUserFromFirestore(user.uid);

        // Keep token fresh on every login
        await saveDeviceToken(user.uid);

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
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;

      if (user != null) {
        // Get real FCM token
        final String? fcmToken = await FirebaseMessaging.instance.getToken();

        await _initializeUserInFirestore(user,
            username: username, fcmToken: fcmToken);
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
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;

      if (user != null) {
        await _fetchUserFromFirestore(user.uid);

        // Refresh FCM token on every login (token can rotate)
        await saveDeviceToken(user.uid);

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
      await _googleSignIn.signOut();
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
  User? getCurrentUser() => _auth.currentUser;

  Future<UserModel> _fetchUserFromFirestore(String userId) async {
    try {
      final DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();

      if (!userDoc.exists) {
        throw Exception('User document not found in Firestore');
      }

      final Map<String, dynamic> userData =
          userDoc.data() as Map<String, dynamic>;

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

  Future<void> _initializeUserInFirestore(
    User user, {
    String username = '',
    String? fcmToken,
  }) async {
    try {
      final DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();

      if (!userDoc.exists) {
        final String displayName =
            username.isNotEmpty ? username : user.displayName ?? 'User';

        final UserModel userModel = UserModel(
          id: user.uid,
          username: displayName,
          email: user.email ?? '',
          profilePicture: user.photoURL ?? '',
          createdAt: DateTime.now(),
          deviceToken: fcmToken, // ← real token saved here
        );

        await _firestore
            .collection('users')
            .doc(user.uid)
            .set(userModel.toFirestoreMap());

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

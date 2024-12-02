import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/models/user.dart';
import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/repository/base/i_auth_repository.dart';
import 'package:expense_tracker/utils/helpers/shared_preference.dart';
import 'package:expense_tracker/utils/helpers/snackbar_util.dart';
import 'package:expense_tracker/view/introduction/introduction.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository implements IAuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Sign up with Google
  @override
  Future<User?> signUpWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        await HTrackerSharedPreferences.setString('userId', user.uid);

        await _initializeUserInFirestore(user);
      }
      return user;
    } catch (e) {
      print('Error signing up with Google: $e');
      throw e;
    }
  }

  // Sign up with email and password
  @override
  Future<User?> signUp(String email, String password, String username) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await sendEmailVerification();
      User? user = userCredential.user;
      if (user != null) {
        await _initializeUserInFirestore(user, username: username);
      }
      return user;
    } catch (e) {
      print('Error signing up: $e');
      throw e;
    }
  }

  // Sign in with email and password
  @override
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      if (user != null) {
        await HTrackerSharedPreferences.setString('userId', user.uid);
        print('User ID ${user.uid} saved in SharedPreferences');
      }
      return user;
    } catch (e) {
      print('Error signing in: $e');
      throw e;
    }
  }

  // Sign out
  @override
  Future<void> signOut() async {
    await _auth.signOut();
    await HTrackerSharedPreferences.removeKey('userId');
    print("User signed out and preferences cleared.");
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      print('Password reset email sent to $email');
    } catch (e) {
      print('Error sending password reset email: $e');
      throw e;
    }
  }

  @override
  Future<void> deleteAccount(BuildContext context) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) throw Exception('No user is signed in');

      // Check if the user signed in with Google
      if (user.providerData
          .any((provider) => provider.providerId == 'google.com')) {
        // Reauthenticate with Google
        await _reauthenticateWithGoogle();
      } else {
        // For email/password users
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: await _getPasswordFromUser(
              context), // Implement a dialog to get the password
        );
        await user.reauthenticateWithCredential(credential);
      }

      // Remove user ID from shared preferences
      await HTrackerSharedPreferences.removeKey('userId');

      // Delete user data from Firestore
      await _firestore.collection('users').doc(user.uid).delete();
      await _firestore.collection('accounts').doc(user.uid).delete();

      // Fetch and delete transactions where "userId" matches the current user's ID
      QuerySnapshot transactionsSnapshot = await _firestore
          .collection('transactions')
          .where("userId", isEqualTo: user.uid)
          .get();

      WriteBatch batch = _firestore.batch();
      for (var doc in transactionsSnapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit(); // Execute the batched delete operation

      // Delete user authentication account
      await user.delete();

      // Navigate to login screen
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return Introduction();
      }));

      print("User account deleted and preferences cleared.");
    } catch (e) {
      print('Error deleting account: $e');

      // Show error message or feedback
      SnackbarUtil.showErrorSnackbar(context, e.toString());

      throw e; // Optionally rethrow the error
    }
  }

// Helper function for Google reauthentication
  Future<void> _reauthenticateWithGoogle() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      throw Exception(
          'Google reauthentication failed: User canceled the sign-in process.');
    }

    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Reauthenticate with the newly obtained credential
    await _auth.currentUser!.reauthenticateWithCredential(credential);
  }

  Future<String> _getPasswordFromUser(BuildContext context) async {
    String password = '';
    await showDialog(
      context: context,
      builder: (context) {
        TextEditingController passwordController = TextEditingController();
        return AlertDialog(
          title: Text('Reauthenticate'),
          content: TextField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(hintText: 'Enter your password'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                password = passwordController.text;
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
    if (password.isEmpty)
      throw Exception('Password is required for reauthentication');
    return password;
  }

  // Send email verification
  Future<void> sendEmailVerification() async {
    User? user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
      print('Verification email sent to ${user.email}');
    }
  }

  // Add user and account to Firestore
  Future<void> _initializeUserInFirestore(User user,
      {String username = ''}) async {
    await HTrackerSharedPreferences.setString('userId', user.uid);

    // Check if user document already exists
    final userDoc = await _firestore.collection('users').doc(user.uid).get();
    if (!userDoc.exists) {
      UserModel userModel = UserModel(
        id: user.uid,
        username: username.isNotEmpty ? username : user.displayName ?? '',
        email: user.email ?? '',
        profilePicture: user.photoURL ?? '',
        createdAt: DateTime.now(),
      );
      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(userModel.toJson());

      AccountModel accountModel = AccountModel(
        userId: user.uid,
        accountName:
            '${username.isNotEmpty ? username : user.displayName ?? 'User'}\'s Account',
        balance: 0.0,
        totalIncome: 0.0,
        totalExpense: 0.0,
        createdAt: Timestamp.now(),
      );
      await _firestore
          .collection('accounts')
          .doc(user.uid)
          .set(accountModel.toMap());
    }
  }

  // Retrieve current user
  @override
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}

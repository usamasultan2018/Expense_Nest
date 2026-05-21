import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:expense_tracker/features/dashboard/view/bottom_nav/bottom_navigator.dart';
import 'package:expense_tracker/features/introduction/view/introduction_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Show loading indicator while waiting for the auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Check if user is logged in
        if (snapshot.hasData && snapshot.data != null) {
          return const BottomNavigatorWidget();
        }

        // If not logged in, show introduction/login
        return const IntroductionScreen();
      },
    );
  }
}

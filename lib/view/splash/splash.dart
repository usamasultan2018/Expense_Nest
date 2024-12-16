import 'package:expense_tracker/components/fade_effect.dart';
import 'package:expense_tracker/utils/appColors.dart';
import 'package:expense_tracker/utils/helpers/shared_preference.dart';
import 'package:expense_tracker/view/dashboard/bottom_nav/bottom_navigator.dart';
import 'package:expense_tracker/view/introduction/introduction.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkUserLoggedIn();
  }

  Future<void> _checkUserLoggedIn() async {
    // Check if the user is saved in preferences
    bool hasUser = UserPreferences.hasUser();

    // Set up a delay before navigating
    Future.delayed(const Duration(seconds: 2), () {
      if (hasUser) {
        // If user is logged in, navigate to the Home screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const BottomNavigatorWidget()),
        );
      } else {
        // If no user is logged in, navigate to the Introduction screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Introduction()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeTransitionEffect(
              child: Image.asset(
                "assets/images/wallet.png",
                height: 250,
                width: double.infinity,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

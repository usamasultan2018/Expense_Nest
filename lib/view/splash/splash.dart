import 'package:expense_tracker/components/fade_effect.dart';
import 'package:expense_tracker/utils/appColors.dart';
import 'package:expense_tracker/utils/helpers/shared_preference.dart';
import 'package:expense_tracker/view/dashboard/bottom_nav/bottom_navigator.dart';
import 'package:expense_tracker/view/introduction/introduction_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
    bool hasUser = UserPreferences.hasUser();

    Future.delayed(const Duration(seconds: 2), () {
      if (hasUser) {
        context.go('/bottom-nav'); // Navigate to the home screen
      } else {
        context.go('/introduction'); // Navigate to the introduction screen
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

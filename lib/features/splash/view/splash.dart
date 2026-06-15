import 'package:animate_do/animate_do.dart';
import 'package:expense_tracker/core/components/update_dialog.dart';
import 'package:expense_tracker/core/service/update_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:expense_tracker/app/routes/route_name.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  static const Duration _navigationDelay = Duration(seconds: 3);

  @override
  void initState() {
    super.initState();
    _checkUserLoggedIn();
  }

  Future<void> _checkUserLoggedIn() async {
    await Future.delayed(_navigationDelay);

    if (!mounted) return;

    final updateAvailable = await UpdateService.isUpdateAvailable();

    if (!mounted) return;

    if (updateAvailable) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const UpdateDialog(),
      );
    }

    if (!mounted) return;

    context.goNamed(RouteName.authWrapper);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ZoomIn(
                duration: const Duration(milliseconds: 700),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.12),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.shadow.withOpacity(0.15),
                        blurRadius: 24,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/images/appp_logo.png',
                    height: 72,
                    width: 72,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              FadeInDown(
                duration: const Duration(milliseconds: 700),
                child: Text(
                  'ExpenseNest',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

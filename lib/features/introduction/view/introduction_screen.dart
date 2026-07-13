import 'package:expense_tracker/core/models/onboarding.dart';
import 'package:expense_tracker/features/introduction/view/widgets/custom_indicator.dart';
import 'package:expense_tracker/features/introduction/view/widgets/onboarding_card.dart';
import 'package:expense_tracker/app/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({super.key});

  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  final PageController pageController = PageController();

  final List<Onboarding> onboardingData = [
    Onboarding(
      title1: 'Track spending instantly',
      description:
          'See where your money goes with a clean and simple overview.',
      image: 'assets/images/appp_logo.png',
    ),
    Onboarding(
      title1: 'Stay organized',
      description:
          'Group your expenses and keep your daily budget under control.',
      image: 'assets/images/appp_logo.png',
    ),
    Onboarding(
      title1: 'Make better decisions',
      description:
          'Turn your spending habits into clear insights you can act on.',
      image: 'assets/images/appp_logo.png',
    ),
  ];

  int currentIndex = 0;

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void _next() {
    if (currentIndex < onboardingData.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      context.pushNamed(RouteName.signup);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isLast = currentIndex == onboardingData.length - 1;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          children: [
            // Skip
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => context.pushNamed(RouteName.signup),
                child: Text(
                  'Skip',
                  style: TextStyle(
                    color: colorScheme.onSurface.withValues(alpha: 0.4),
                    fontSize: 14,
                  ),
                ),
              ),
            ),

            // Pages
            Expanded(
              child: PageView.builder(
                controller: pageController,
                itemCount: onboardingData.length,
                onPageChanged: (v) => setState(() => currentIndex = v),
                itemBuilder: (_, i) => OnBoardingCard(
                  index: i,
                  onboarding: onboardingData[i],
                ),
              ),
            ),

            // Dots
            CustomIndicator(
              position: currentIndex,
              dotsCount: onboardingData.length,
            ),

            const SizedBox(height: 32),

            // Next / Get Started
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton(
                onPressed: _next,
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  isLast ? 'Get Started' : 'Next',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Log in
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account?',
                  style: TextStyle(
                    fontSize: 13,
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
                TextButton(
                  onPressed: () => context.pushNamed(RouteName.login),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Log In',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

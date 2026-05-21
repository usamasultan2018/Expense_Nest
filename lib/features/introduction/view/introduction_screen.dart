import 'package:expense_tracker/core/components/custom_button.dart';
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
  final PageController pageController = PageController(initialPage: 0);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              Expanded(
                flex: 2,
                child: PageView.builder(
                  itemCount: onboardingData.length,
                  controller: pageController,
                  onPageChanged: (value) {
                    setState(() {
                      currentIndex = value;
                    });
                  },
                  itemBuilder: (context, index) {
                    return OnBoardingCard(
                      index: index,
                      onboarding: onboardingData[index],
                    );
                  },
                ),
              ),
              CustomIndicator(
                position: currentIndex,
                dotsCount: onboardingData.length,
              ),
              const SizedBox(height: 20),
              RoundButton(
                  title: "Sign Up",
                  onPressed: () {
                    context.pushNamed(RouteName.signup);
                  }),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.7)),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: () {
                      context.pushNamed(RouteName.login);
                    },
                    child: const Text("Log In"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

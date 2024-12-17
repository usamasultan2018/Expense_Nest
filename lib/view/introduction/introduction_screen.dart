import 'package:animate_do/animate_do.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:expense_tracker/components/custom_button.dart';
import 'package:expense_tracker/utils/appColors.dart';
import 'package:expense_tracker/view/auth/login/login_screen.dart';
import 'package:expense_tracker/view/auth/signup/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({super.key});

  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  PageController pageController = PageController(initialPage: 0);
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Onboarding> onboardingData = [
      Onboarding(
        title1: AppLocalizations.of(context)!.onboardingTitle1,
        description: AppLocalizations.of(context)!.onboardingDescription1,
        image: "assets/images/appp_logo.png",
      ),
      Onboarding(
        title1: AppLocalizations.of(context)!.onboardingTitle2,
        description: AppLocalizations.of(context)!.onboardingDescription2,
        image: "assets/images/appp_logo.png",
      ),
      Onboarding(
        title1: AppLocalizations.of(context)!.onboardingTitle3,
        description: AppLocalizations.of(context)!.onboardingDescription3,
        image: "assets/images/appp_logo.png",
      ),
    ];

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
              CustomIndicator(position: currentIndex),
              const SizedBox(height: 20),
              RoundButton(
                  title: AppLocalizations.of(context)!.signupButton,
                  onPress: () {
                    context.push('/signup');
                  }),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  context.push('/login');
                },
                child: Text(
                  AppLocalizations.of(context)!.alreadyHaveAccount,
                  style: TextStyle(
                    fontSize: 15,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
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

class Onboarding {
  final String image;
  final String title1;
  final String description;

  Onboarding({
    required this.title1,
    required this.description,
    required this.image,
  });
}

class CustomIndicator extends StatelessWidget {
  final int position;
  const CustomIndicator({required this.position, super.key});

  @override
  Widget build(BuildContext context) {
    return DotsIndicator(
      dotsCount: 3, // Total number of onboarding screens
      position: position,
      decorator: DotsDecorator(
        color: Colors.grey.withOpacity(0.5),
        size: const Size.square(8.0),
        activeSize: const Size(20.0, 8.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        activeColor: AppColors.secondary,
      ),
    );
  }
}

class OnBoardingCard extends StatelessWidget {
  final Onboarding onboarding;
  final int index;
  const OnBoardingCard({
    super.key,
    required this.onboarding,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInDown(
      duration: const Duration(milliseconds: 1400),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            onboarding.image,
            width: 100,
            height: 100,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              onboarding.title1,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          Text(
            onboarding.description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }
}

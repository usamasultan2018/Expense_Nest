import 'package:animate_do/animate_do.dart';
import 'package:expense_tracker/core/models/onboarding.dart';
import 'package:flutter/material.dart';

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

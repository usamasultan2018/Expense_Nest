import 'package:flutter/material.dart';

class TransactionCardSkeleton extends StatelessWidget {
  const TransactionCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              TileSkeleton(
                height: 40,
                width: 40,
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TileSkeleton(
                    height: 10,
                    width: 100,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TileSkeleton(
                    height: 10,
                    width: 60,
                  ),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TileSkeleton(
                height: 10,
                width: 100,
              ),
              SizedBox(
                height: 10,
              ),
              TileSkeleton(
                height: 10,
                width: 60,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class WelcomeSkeleton extends StatelessWidget {
  const WelcomeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(10.0),
      child: Row(
        children: [
          CircleSkeleton(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TileSkeleton(
                height: 10,
                width: 60,
              ),
              SizedBox(
                height: 5,
              ),
              TileSkeleton(
                height: 10,
                width: 100,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BalanceCardTileSkeleton extends StatelessWidget {
  const BalanceCardTileSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TileSkeleton(
              width: 100, height: 20), // Placeholder for "Total Balance" text
          SizedBox(height: 10),
          TileSkeleton(
              width: 150, height: 40), // Placeholder for balance amount
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleSkeleton(size: 28), // Placeholder for icon
                  SizedBox(width: 8),
                  Column(
                    children: [
                      TileSkeleton(
                          width: 50,
                          height: 14), // Placeholder for "Income" label
                      SizedBox(height: 4),
                      TileSkeleton(
                          width: 60,
                          height: 14), // Placeholder for income amount
                    ],
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleSkeleton(size: 28), // Placeholder for icon
                  SizedBox(width: 8),
                  Column(
                    children: [
                      TileSkeleton(
                          width: 50,
                          height: 14), // Placeholder for "Expense" label
                      SizedBox(height: 4),
                      TileSkeleton(
                          width: 60,
                          height: 14), // Placeholder for expense amount
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TileSkeleton extends StatelessWidget {
  const TileSkeleton({Key? key, this.height, this.width}) : super(key: key);

  final double? height, width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: const EdgeInsets.all(16 / 2),
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.all(Radius.circular(16))),
    );
  }
}

class CircleSkeleton extends StatelessWidget {
  const CircleSkeleton({Key? key, this.size = 24}) : super(key: key);

  final double? size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.04),
        shape: BoxShape.circle,
      ),
    );
  }
}

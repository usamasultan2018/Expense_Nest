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
          CircleSkeleton(
            size: 60,
          ),
          SizedBox(
            width: 5,
          ),
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
      height: 150,
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.all(Radius.circular(8))),
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
          borderRadius: const BorderRadius.all(Radius.circular(8))),
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
        color: Theme.of(context).cardColor,
        shape: BoxShape.circle,
      ),
    );
  }
}

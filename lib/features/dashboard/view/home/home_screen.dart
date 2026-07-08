import 'package:expense_tracker/core/components/app_app_bar.dart';
import 'package:expense_tracker/features/dashboard/view/bottom_nav/controller/bottom_nav_controller.dart';
import 'package:expense_tracker/features/dashboard/view/home/widgets/balance_overview.dart';
import 'package:expense_tracker/features/dashboard/view/home/widgets/recent_transactions.dart';
import 'package:expense_tracker/features/dashboard/view/profile/controller/user_controller.dart';
import 'package:expense_tracker/features/subscription/widgets/premium_banner_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserController>().fetchUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const AppAppBar.home(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await context.read<UserController>().fetchUser();
          },
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              const SizedBox(height: 20),
              const BalanceOverview(),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Transactions",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  TextButton(
                    onPressed: () {
                      context.read<BottomNavController>().setIndex(1);
                    },
                    child: Text("View All",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const RecentTransactions(),
              const SizedBox(height: 16),
              const PremiumBannerCard(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

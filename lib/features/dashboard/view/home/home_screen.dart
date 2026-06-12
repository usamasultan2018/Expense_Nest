import 'package:expense_tracker/features/dashboard/view/home/widgets/balance_overview.dart';
import 'package:expense_tracker/features/dashboard/view/home/widgets/recent_transactions.dart';
import 'package:expense_tracker/features/dashboard/view/home/widgets/user_greeting.dart';
import 'package:expense_tracker/features/dashboard/view/profile/controller/user_controller.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const UserGreeting(),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
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
              Text(
                "Transactions",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 10),
              const RecentTransactions(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:expense_tracker/features/dashboard/view/home/widgets/balance_overview.dart';
import 'package:expense_tracker/features/dashboard/view/home/widgets/recent_transactions.dart';
import 'package:expense_tracker/features/dashboard/view/home/widgets/user_greeting.dart';
import 'package:expense_tracker/features/user/controller/user_controller.dart';
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
    // Fetch the latest user info when the home screen loads
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
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const BalanceOverview(),
                const SizedBox(height: 20),
                Text(
                  "Transaction",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 10),
                const RecentTransactions(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

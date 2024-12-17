import 'package:expense_tracker/view/dashboard/home/widgets/balance_card.dart';
import 'package:expense_tracker/view/dashboard/home/widgets/transaction.dart';
import 'package:expense_tracker/view/dashboard/home/widgets/userdata.dart';
import 'package:expense_tracker/view/dashboard/home/widgets/view_all.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const UserData(),
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                BalanceCard(),
                SizedBox(height: 30),
                ViewAll(),
                SizedBox(height: 10),
                Transactions(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

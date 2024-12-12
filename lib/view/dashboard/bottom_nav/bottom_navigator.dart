import 'package:expense_tracker/view/dashboard/stats/stats_screen.dart';
import 'package:expense_tracker/view/dashboard/transactions/add_transaction.dart';
import 'package:expense_tracker/view/dashboard/home/home.dart';
import 'package:expense_tracker/utils/appColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BottomNavigatorWidget extends StatefulWidget {
  const BottomNavigatorWidget({super.key});

  @override
  State<BottomNavigatorWidget> createState() => _BottomNavigatorWidgetState();
}

class _BottomNavigatorWidgetState extends State<BottomNavigatorWidget> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const HomeView(),
    StatScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      // Bottom Navigation Bar
      bottomNavigationBar: NavigationBar(
        height: 70,
        indicatorColor: AppColors.secondary.withOpacity(0.4),
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: theme.cardColor,
        destinations: [
          NavigationDestination(
            icon: Icon(CupertinoIcons.home),
            label: AppLocalizations.of(context)!.home,
          ),
          NavigationDestination(
            icon: Icon(CupertinoIcons.graph_square_fill),
            label: AppLocalizations.of(context)!.stats,
          ),
        ],
      ),

      // Floating Action Button
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (ctx) => const AddTransaction()));
        },
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppColors.primaryGradient,
          ),
          child: const Icon(
            CupertinoIcons.add,
            color: Colors.white,
          ),
        ),
      ),

      // Body with IndexedStack for navigation
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
    );
  }
}

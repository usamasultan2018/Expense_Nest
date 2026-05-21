import 'package:expense_tracker/features/dashboard/view/stats/stats_screen.dart';
import 'package:expense_tracker/features/dashboard/view/transactions/add_transaction.dart';
import 'package:expense_tracker/features/dashboard/view/home/home_screen.dart';
import 'package:expense_tracker/core/theme/appColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomNavigatorWidget extends StatefulWidget {
  const BottomNavigatorWidget({super.key});

  @override
  State<BottomNavigatorWidget> createState() => _BottomNavigatorWidgetState();
}

class _BottomNavigatorWidgetState extends State<BottomNavigatorWidget> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const HomeScreen(),
    const StatScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        height: 70,
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(35),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 25,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Home Icon
              Expanded(
                child: _buildNavItem(
                  icon: FontAwesomeIcons.house,
                  index: 0,
                ),
              ),

              // Center Floating Action Button
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.primaryGradient,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.secondary.withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (ctx) => const AddTransaction()),
                    );
                  },
                  icon: const Icon(
                    CupertinoIcons.add,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),

              // Stats Icon
              Expanded(
                child: _buildNavItem(
                  icon: FontAwesomeIcons.chartLine,
                  index: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required int index,
  }) {
    final isSelected = _currentIndex == index;

    return InkWell(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      borderRadius: BorderRadius.circular(25),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: isSelected
            ? const EdgeInsets.symmetric(
                horizontal: 8,
              )
            : const EdgeInsets.all(0),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.secondary.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          icon,
          color: isSelected ? AppColors.secondary : Colors.grey.shade500,
          size: isSelected ? 26 : 24,
        ),
      ),
    );
  }
}

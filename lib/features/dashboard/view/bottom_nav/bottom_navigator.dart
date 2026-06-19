import 'package:expense_tracker/app/routes/route_name.dart';
import 'package:expense_tracker/features/dashboard/view/bottom_nav/controller/bottom_nav_controller.dart';
import 'package:expense_tracker/features/dashboard/view/budget/budget_screen.dart';
import 'package:expense_tracker/features/dashboard/view/home/home_screen.dart';
import 'package:expense_tracker/features/dashboard/view/home/view/all_transaction_screen.dart';
import 'package:expense_tracker/features/dashboard/view/stats/stats_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class BottomNavigatorWidget extends StatelessWidget {
  const BottomNavigatorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final navController = context.watch<BottomNavController>();

    final screens = const [
      HomeScreen(),
      AllTransactionScreen(),
      BudgetScreen(),
      StatScreen(),
    ];

    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: navController.currentIndex,
        children: screens,
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildNavItem(
                  context,
                  icon: Icons.home_rounded,
                  label: "Home",
                  index: 0,
                ),
              ),
              Expanded(
                child: _buildNavItem(
                  context,
                  icon: Icons.receipt_long_rounded,
                  label: "Expenses",
                  index: 1,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                height: 58,
                width: 58,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () {
                    context.push(RouteName.addTransaction);
                  },
                  icon: Icon(
                    Icons.add_rounded,
                    color: colorScheme.onPrimary,
                    size: 30,
                  ),
                ),
              ),
              Expanded(
                child: _buildNavItem(
                  context,
                  icon: Icons.account_balance_wallet_rounded,
                  label: "Budget",
                  index: 2,
                ),
              ),
              Expanded(
                child: _buildNavItem(
                  context,
                  icon: Icons.bar_chart_rounded,
                  label: "Reports",
                  index: 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required int index,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final currentIndex = context.watch<BottomNavController>().currentIndex;

    final isSelected = currentIndex == index;

    return InkWell(
      onTap: () {
        context.read<BottomNavController>().setIndex(index);
      },
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 26,
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

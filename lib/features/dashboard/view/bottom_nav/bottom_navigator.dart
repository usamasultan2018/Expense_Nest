import 'package:expense_tracker/app/routes/route_name.dart';
import 'package:expense_tracker/features/dashboard/view/home/home_screen.dart';
import 'package:expense_tracker/features/dashboard/view/stats/stats_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavigatorWidget extends StatefulWidget {
  const BottomNavigatorWidget({super.key});

  @override
  State<BottomNavigatorWidget> createState() => _BottomNavigatorWidgetState();
}

class _BottomNavigatorWidgetState extends State<BottomNavigatorWidget> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    StatScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildNavItem(
                  icon: Icons.home_rounded,
                  label: "Home",
                  index: 0,
                  colorScheme: colorScheme,
                ),
              ),

              // Center FAB-style button
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: colorScheme.primary,
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.shadow.withValues(alpha: 0.12),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: () {
                    // TODO: Implement add expense action
                    context.push(RouteName.addTransaction);
                  },
                  icon: Icon(
                    Icons.add,
                    color: colorScheme.onPrimary,
                  ),
                ),
              ),

              Expanded(
                child: _buildNavItem(
                  icon: Icons.bar_chart_rounded,
                  label: "Stats",
                  index: 1,
                  colorScheme: colorScheme,
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
    required String label,
    required int index,
    required ColorScheme colorScheme,
  }) {
    final bool isSelected = _currentIndex == index;

    return InkWell(
      onTap: () => setState(() => _currentIndex = index),
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              scale: isSelected ? 1.15 : 1.0,
              duration: const Duration(milliseconds: 250),
              child: Icon(
                icon,
                size: 26,
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.5,
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

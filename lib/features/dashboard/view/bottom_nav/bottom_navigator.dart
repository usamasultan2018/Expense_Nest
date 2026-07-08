import 'dart:math' as math;
import 'dart:ui';
import 'package:expense_tracker/app/routes/route_name.dart';
import 'package:expense_tracker/core/utils/constant.dart';
import 'package:expense_tracker/features/dashboard/view/bottom_nav/controller/bottom_nav_controller.dart';
import 'package:expense_tracker/features/dashboard/view/budget/budget_screen.dart';
import 'package:expense_tracker/features/dashboard/view/home/home_screen.dart';
import 'package:expense_tracker/features/dashboard/view/home/view/all_transaction_screen.dart';
import 'package:expense_tracker/features/dashboard/view/stats/stats_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// ─── Nav item model ──────────────────────────────────────────────────────────

class _NavItem {
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
  final IconData icon;
  final IconData activeIcon;
  final String label;
}

const _navItems = [
  _NavItem(
    icon: Icons.home_outlined,
    activeIcon: Icons.home_rounded,
    label: 'Home',
  ),
  _NavItem(
    icon: Icons.receipt_long_outlined,
    activeIcon: Icons.receipt_long_rounded,
    label: 'Expenses',
  ),
  _NavItem(
    icon: Icons.account_balance_wallet_outlined,
    activeIcon: Icons.account_balance_wallet_rounded,
    label: 'Budget',
  ),
  _NavItem(
    icon: Icons.bar_chart_outlined,
    activeIcon: Icons.bar_chart_rounded,
    label: 'Reports',
  ),
];

// ─── FAB action model ─────────────────────────────────────────────────────────

class _FabAction {
  const _FabAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.type,
  });
  final IconData icon;
  final String label;
  final Color color;
  final String type;
}

const _fabActions = [
  _FabAction(
    icon: Icons.arrow_downward_rounded,
    label: 'Income',
    color: Color(0xFF00C896),
    type: 'income',
  ),
  _FabAction(
    icon: Icons.arrow_upward_rounded,
    label: 'Expense',
    color: Color(0xFFFF5B5B),
    type: 'expense',
  ),
  _FabAction(
    icon: Icons.account_balance_wallet_rounded,
    label: 'Budget',
    color: Color(0xFF7C6FFF),
    type: 'budget',
  ),
];

// ─── Main widget ──────────────────────────────────────────────────────────────

class BottomNavigatorWidget extends StatefulWidget {
  const BottomNavigatorWidget({super.key});

  @override
  State<BottomNavigatorWidget> createState() => _BottomNavigatorWidgetState();
}

class _BottomNavigatorWidgetState extends State<BottomNavigatorWidget>
    with TickerProviderStateMixin {
  bool _isMenuOpen = false;

  // FAB open/close animation
  late final AnimationController _fabController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 420),
  );

  // Staggered chip animations
  late final List<Animation<double>> _chipAnimations =
      List.generate(_fabActions.length, (i) {
    final start = i * 0.10;
    final end = (start + 0.60).clamp(0.0, 1.0);
    return CurvedAnimation(
      parent: _fabController,
      curve: Interval(start, end, curve: Curves.easeOutBack),
      reverseCurve: Interval(start, end, curve: Curves.easeInCubic),
    );
  });

  // FAB + icon rotation (0 → 135°)
  late final Animation<double> _fabRotation = Tween<double>(
    begin: 0,
    end: 0.375,
  ).animate(CurvedAnimation(parent: _fabController, curve: Curves.easeOutBack));

  // Per-tab spring-bounce controllers
  late final List<AnimationController> _tabControllers =
      List.generate(_navItems.length, (i) {
    return AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
      lowerBound: 0.85,
      upperBound: 1.0,
      value: 1.0,
    );
  });

  @override
  void dispose() {
    _fabController.dispose();
    for (final c in _tabControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _toggleMenu() {
    HapticFeedback.lightImpact();
    setState(() {
      _isMenuOpen = !_isMenuOpen;
      _isMenuOpen ? _fabController.forward() : _fabController.reverse();
    });
  }

  void _closeMenu() {
    if (_isMenuOpen) {
      setState(() {
        _isMenuOpen = false;
        _fabController.reverse();
      });
    }
  }

  void _onNavTap(int index, BottomNavController ctrl) {
    if (ctrl.currentIndex == index) return;
    HapticFeedback.selectionClick();
    _closeMenu();
    _tabControllers[index]
        .reverse()
        .then((_) => _tabControllers[index].forward());
    ctrl.setIndex(index);
  }

  void _onActionTap(String type) {
    HapticFeedback.selectionClick();
    _closeMenu();
    if (type == 'budget') {
      context.push(RouteName.addBudget);
      return;
    }
    final transactionType =
        type == 'income' ? TransactionType.income : TransactionType.expense;
    context.push(RouteName.addTransaction, extra: {'type': transactionType});
  }

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
      body: Stack(
        children: [
          // ── Screen stack
          IndexedStack(
            index: navController.currentIndex,
            children: screens,
          ),

          // ── Blurred backdrop
          IgnorePointer(
            ignoring: !_isMenuOpen,
            child: AnimatedBuilder(
              animation: _fabController,
              builder: (_, __) => Opacity(
                opacity: _fabController.value * 0.85,
                child: GestureDetector(
                  onTap: _closeMenu,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 6 * _fabController.value,
                      sigmaY: 6 * _fabController.value,
                    ),
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.30),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Action chips
          _RadialActionMenu(
            chipAnimations: _chipAnimations,
            isOpen: _isMenuOpen,
            onTap: _onActionTap,
          ),
        ],
      ),

      // ── Bottom nav bar ────────────────────────────────────────────────────
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: _GlassNavBar(
                colorScheme: colorScheme,
                navController: navController,
                tabControllers: _tabControllers,
                fabRotation: _fabRotation,
                isMenuOpen: _isMenuOpen,
                onNavTap: _onNavTap,
                onFabTap: _toggleMenu,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Glass nav bar ────────────────────────────────────────────────────────────

class _GlassNavBar extends StatelessWidget {
  const _GlassNavBar({
    required this.colorScheme,
    required this.navController,
    required this.tabControllers,
    required this.fabRotation,
    required this.isMenuOpen,
    required this.onNavTap,
    required this.onFabTap,
  });

  final ColorScheme colorScheme;
  final BottomNavController navController;
  final List<AnimationController> tabControllers;
  final Animation<double> fabRotation;
  final bool isMenuOpen;
  final void Function(int, BottomNavController) onNavTap;
  final VoidCallback onFabTap;

  @override
  Widget build(BuildContext context) {
    final isDark = colorScheme.brightness == Brightness.dark;
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: isDark
            ? colorScheme.surface.withValues(alpha: 0.75)
            : colorScheme.surface.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.white.withValues(alpha: 0.60),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.12),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.06),
            blurRadius: 40,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          for (int i = 0; i < 2; i++)
            Expanded(
              child: _AnimatedNavTab(
                item: _navItems[i],
                isSelected: navController.currentIndex == i,
                controller: tabControllers[i],
                colorScheme: colorScheme,
                onTap: () => onNavTap(i, navController),
              ),
            ),
          _CenterFab(
            colorScheme: colorScheme,
            rotation: fabRotation,
            isOpen: isMenuOpen,
            onTap: onFabTap,
          ),
          for (int i = 2; i < 4; i++)
            Expanded(
              child: _AnimatedNavTab(
                item: _navItems[i],
                isSelected: navController.currentIndex == i,
                controller: tabControllers[i],
                colorScheme: colorScheme,
                onTap: () => onNavTap(i, navController),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Single animated nav tab ──────────────────────────────────────────────────

class _AnimatedNavTab extends StatelessWidget {
  const _AnimatedNavTab({
    required this.item,
    required this.isSelected,
    required this.controller,
    required this.colorScheme,
    required this.onTap,
  });

  final _NavItem item;
  final bool isSelected;
  final AnimationController controller;
  final ColorScheme colorScheme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final activeColor = colorScheme.primary;
    final inactiveColor = colorScheme.onSurface.withValues(alpha: 0.45);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: ScaleTransition(
        scale: controller,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon with animated pill highlight
            AnimatedContainer(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected
                    ? activeColor.withValues(alpha: 0.12)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(14),
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                transitionBuilder: (child, anim) => ScaleTransition(
                  scale: anim,
                  child: FadeTransition(opacity: anim, child: child),
                ),
                child: Icon(
                  isSelected ? item.activeIcon : item.icon,
                  key: ValueKey(isSelected),
                  size: 24,
                  color: isSelected ? activeColor : inactiveColor,
                ),
              ),
            ),
            const SizedBox(height: 3),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 280),
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? activeColor : inactiveColor,
                letterSpacing: isSelected ? 0.3 : 0,
              ),
              child: Text(item.label),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Centre gradient FAB ──────────────────────────────────────────────────────

class _CenterFab extends StatelessWidget {
  const _CenterFab({
    required this.colorScheme,
    required this.rotation,
    required this.isOpen,
    required this.onTap,
  });

  final ColorScheme colorScheme;
  final Animation<double> rotation;
  final bool isOpen;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedBuilder(
          animation: rotation,
          builder: (_, child) => Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colorScheme.primary,
                  Color.lerp(colorScheme.primary, colorScheme.tertiary, 0.5)!,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primary
                      .withValues(alpha: isOpen ? 0.55 : 0.35),
                  blurRadius: isOpen ? 24 : 14,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Center(
              child: Transform.rotate(
                angle: rotation.value * 2 * math.pi,
                child: child,
              ),
            ),
          ),
          child: Icon(
            Icons.add_rounded,
            color: colorScheme.onPrimary,
            size: 30,
          ),
        ),
      ),
    );
  }
}

// ─── Radial action menu ───────────────────────────────────────────────────────

class _RadialActionMenu extends StatelessWidget {
  const _RadialActionMenu({
    required this.chipAnimations,
    required this.isOpen,
    required this.onTap,
  });

  final List<Animation<double>> chipAnimations;
  final bool isOpen;
  final void Function(String) onTap;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 110,
      left: 0,
      right: 0,
      child: IgnorePointer(
        ignoring: !isOpen,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (int i = 0; i < _fabActions.length; i++) ...[
                _ActionChip(
                  animation: chipAnimations[i],
                  action: _fabActions[i],
                  onTap: () => onTap(_fabActions[i].type),
                ),
                if (i < _fabActions.length - 1) const SizedBox(height: 10),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Single frosted-glass action chip ────────────────────────────────────────

class _ActionChip extends StatelessWidget {
  const _ActionChip({
    required this.animation,
    required this.action,
    required this.onTap,
  });

  final Animation<double> animation;
  final _FabAction action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (_, child) {
        final v = animation.value.clamp(0.0, 1.0);
        return Opacity(
          opacity: v,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - v)),
            child: Transform.scale(scale: 0.75 + 0.25 * v, child: child),
          ),
        );
      },
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: action.color.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: action.color.withValues(alpha: 0.35),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: action.color.withValues(alpha: 0.25),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: action.color,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: action.color.withValues(alpha: 0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(action.icon, color: Colors.white, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    action.label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: action.color,
                      letterSpacing: 0.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

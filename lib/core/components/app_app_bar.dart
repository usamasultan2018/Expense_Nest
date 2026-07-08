import 'package:expense_tracker/core/components/profile_avatar.dart';
import 'package:expense_tracker/features/dashboard/view/profile/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// A unified, reusable app bar for the entire Expense Nest app.
///
/// Two variants are supported via named constructors:
///   • [AppAppBar.title]   — standard title + optional actions
///   • [AppAppBar.home]    — avatar + greeting on the left, optional actions on the right
///
/// Both variants respect the current theme's surface colour and add a subtle
/// bottom divider for visual separation.
class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  // ── common fields ─────────────────────────────────────────────────────────
  final _Variant _variant;
  final String? title;
  final List<Widget>? actions;
  final bool showBack;
  final Widget? leading;

  // ── private constructors ──────────────────────────────────────────────────

  const AppAppBar._({
    required _Variant variant,
    this.title,
    this.actions,
    this.showBack = false,
    this.leading,
  }) : _variant = variant;

  // ── public named constructors ─────────────────────────────────────────────

  /// Standard app bar with a bold centred title and optional action buttons.
  const AppAppBar.title(
    String title, {
    List<Widget>? actions,
    bool showBack = false,
  }) : this._(
          variant: _Variant.title,
          title: title,
          actions: actions,
          showBack: showBack,
        );

  /// Home-screen variant: avatar on the left, greeting text, optional actions.
  const AppAppBar.home({
    List<Widget>? actions,
  }) : this._(
          variant: _Variant.home,
          actions: actions,
        );

  // ── PreferredSizeWidget ───────────────────────────────────────────────────

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  // ── build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return switch (_variant) {
      _Variant.title => _TitleBar(
          title: title!,
          actions: actions,
          showBack: showBack,
          colorScheme: colorScheme,
        ),
      _Variant.home => _HomeBar(
          actions: actions,
          colorScheme: colorScheme,
        ),
    };
  }
}

enum _Variant { title, home }

// ══════════════════════════════════════════════════════════════════════════════
// _TitleBar — "Budget", "Analytics", etc.
// ══════════════════════════════════════════════════════════════════════════════

class _TitleBar extends StatelessWidget implements PreferredSizeWidget {
  const _TitleBar({
    required this.title,
    required this.colorScheme,
    this.actions,
    this.showBack = false,
  });

  final String title;
  final ColorScheme colorScheme;
  final List<Widget>? actions;
  final bool showBack;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0.5,
      backgroundColor: colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarBrightness: colorScheme.brightness,
        statusBarIconBrightness: colorScheme.brightness == Brightness.light
            ? Brightness.dark
            : Brightness.light,
      ),
      automaticallyImplyLeading: showBack,
      centerTitle: false,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: colorScheme.onSurface,
          letterSpacing: -0.3,
        ),
      ),
      actions: [
        if (actions != null) ...actions!,
        const SizedBox(width: 4),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// _HomeBar — avatar + greeting + time-sensitive welcome text
// ══════════════════════════════════════════════════════════════════════════════

class _HomeBar extends StatelessWidget implements PreferredSizeWidget {
  const _HomeBar({required this.colorScheme, this.actions});

  final ColorScheme colorScheme;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  String get _emoji {
    final hour = DateTime.now().hour;
    if (hour < 12) return '☀️';
    if (hour < 17) return '👋';
    return '🌙';
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0.5,
      backgroundColor: colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: false,
      title: Consumer<UserController>(
        builder: (context, uc, _) {
          final user = uc.currentUser;

          // Loading skeleton
          if (uc.isLoading && user == null) {
            return _GreetingSkeleton(colorScheme: colorScheme);
          }

          if (user == null) return const SizedBox.shrink();

          return Row(
            children: [
              // ── Avatar ──────────────────────────────────────────────────
              GestureDetector(
                onTap: () => context.push('/profile'),
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: colorScheme.primary.withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                  child: ProfileAvatar(
                    radius: 20,
                    networkImageUrl: user.profilePicture,
                    borderWidth: 0,
                    shadowBlurRadius: 0,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // ── Greeting + name ─────────────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$_greeting $_emoji',
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurface.withValues(alpha: 0.55),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      user.username,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      actions: [
        if (actions != null) ...actions!,
        const SizedBox(width: 4),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Loading skeleton for the home greeting row
// ══════════════════════════════════════════════════════════════════════════════

class _GreetingSkeleton extends StatelessWidget {
  const _GreetingSkeleton({required this.colorScheme});
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final base = colorScheme.onSurface.withValues(alpha: 0.08);
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(shape: BoxShape.circle, color: base),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                width: 90, height: 11, decoration: BoxDecoration(color: base, borderRadius: BorderRadius.circular(6))),
            const SizedBox(height: 6),
            Container(
                width: 130, height: 14, decoration: BoxDecoration(color: base, borderRadius: BorderRadius.circular(6))),
          ],
        ),
      ],
    );
  }
}

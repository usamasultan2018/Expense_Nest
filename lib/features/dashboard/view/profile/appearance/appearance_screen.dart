import 'package:expense_tracker/features/dashboard/view/profile/appearance/widgets/color_scheme_tile.dart';
import 'package:expense_tracker/features/dashboard/view/profile/appearance/widgets/font_tile.dart';
import 'package:expense_tracker/features/dashboard/view/profile/appearance/widgets/theme_tile.dart';
import 'package:flutter/material.dart';

class AppearanceScreen extends StatelessWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: false,
        title: const Text(
          "Appearance",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            "PERSONALIZATION",
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: colorScheme.outlineVariant.withValues(alpha: 0.4),
              ),
            ),
            child: const Column(
              children: [
                ThemeTile(),
                Divider(height: 1, indent: 72),
                ColorSchemeTile(),
                Divider(height: 1, indent: 72),
                FontTile(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:expense_tracker/features/dashboard/view/profile/appearance/widgets/color_scheme_tile.dart';
import 'package:expense_tracker/features/dashboard/view/profile/appearance/widgets/theme_tile.dart';
import 'package:flutter/material.dart';

class AppearanceScreen extends StatelessWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Appearance"),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ThemeTile(),
            //color scheme tile can

            SizedBox(height: 16),

            ColorSchemeTile(),
          ],
        ),
      ),
    );
  }
}

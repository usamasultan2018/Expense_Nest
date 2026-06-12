import 'package:flutter/material.dart';

class NoGraphTransaction extends StatelessWidget {
  const NoGraphTransaction({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: [
                Icon(
                  Icons.pie_chart,
                  color: colorScheme.onSurfaceVariant,
                  size: 40,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "No transactions",
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

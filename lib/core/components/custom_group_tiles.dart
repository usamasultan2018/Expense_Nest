import 'package:flutter/material.dart';

class CustomTileGroup extends StatelessWidget {
  final List<Widget> children;

  const CustomTileGroup({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        children: List.generate(children.length, (index) {
          return Column(
            children: [
              children[index],
              if (index != children.length - 1)
                Divider(
                  height: 1,
                  indent: 70,
                  color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                ),
            ],
          );
        }),
      ),
    );
  }
}

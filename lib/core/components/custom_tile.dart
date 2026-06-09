import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class CustomTile extends StatelessWidget {
  final String title;
  final IconData iconData;
  final Color? bckColor;
  final VoidCallback? onTap;

  const CustomTile({
    super.key,
    required this.title,
    required this.iconData,
    this.onTap,
    this.bckColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final tileColor = bckColor ?? colorScheme.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 18,
          ),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: theme.dividerColor.withValues(alpha: 0.08),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // ICON BOX
              Container(
                height: 56,
                width: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: tileColor,
                ),
                child: Icon(
                  iconData,
                  color: Colors.white,
                  size: 26,
                ),
              ),

              const SizedBox(width: 16),

              // TITLE
              Expanded(
                child: AutoSizeText(
                  title,
                  maxLines: 1,
                  minFontSize: 14,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
              ),

              // ARROW
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colorScheme.onSurface.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

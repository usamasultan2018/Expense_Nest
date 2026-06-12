import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class ConfirmationDialogUtil {
  static Future<void> show({
    required BuildContext context,
    required String title,
    required String message,
    required VoidCallback onConfirm,
    String? cancelText,
    String? confirmText,
    bool isDanger = false,
  }) async {
    return showDialog(
      context: context,
      builder: (dialogContext) {
        final theme = Theme.of(dialogContext);
        final colorScheme = theme.colorScheme;

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: colorScheme.surface,
          title: Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            message,
            style: theme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                cancelText ?? "Cancel",
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                onConfirm();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isDanger ? colorScheme.error : colorScheme.primary,
                foregroundColor:
                    isDanger ? colorScheme.onError : colorScheme.onPrimary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                confirmText ?? "Confirm",
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static Future<void> showBottomSheet({
    required BuildContext context,
    required Widget child,
    double? height,
    Color? backgroundColor,
  }) async {
    return showModalBottomSheet(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return FadeInUp(
          child: FractionallySizedBox(
            widthFactor: 1,
            heightFactor: 0.6,
            child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 20.0,
                    right: 20.0,
                    top: 20.0,
                    bottom: MediaQuery.of(context)
                        .viewInsets
                        .bottom, // Adjust for keyboard
                  ),
                  child: child,
                )),
          ),
        );
      },
    );
  }
}

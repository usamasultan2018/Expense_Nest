import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateDialog extends StatelessWidget {
  const UpdateDialog({super.key});

  static const String _playStoreUrl =
      'https://play.google.com/store/apps/details?id=com.softtures.expensenest';

  Future<void> _openStore() async {
    await launchUrl(
      Uri.parse(_playStoreUrl),
      mode: LaunchMode.externalApplication,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 24,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.primaryContainer,
              ),
              child: Icon(
                Icons.system_update_alt_rounded,
                size: 42,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Update Available",
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              "A newer version of ExpenseNest is available. Update now to enjoy the latest improvements and fixes.",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton.icon(
                onPressed: _openStore,
                icon: const Icon(Icons.download_rounded),
                label: const Text("Update Now"),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Later"),
            ),
          ],
        ),
      ),
    );
  }
}

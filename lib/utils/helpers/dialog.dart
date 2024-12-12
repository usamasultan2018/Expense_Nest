import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<bool?> showDeleteConfirmationDialog(
    BuildContext context, String title, String content) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false, // Dialog cannot be dismissed by tapping outside
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor:
            Theme.of(context).cardColor, // Set the background to card color
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context, false); // Cancel the deletion
            },
            child: Text(AppLocalizations.of(context)!.cancel), // Cancel button
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, true); // Confirm the deletion
            },
            child: Text(AppLocalizations.of(context)!.delete), // Delete button
          ),
        ],
      );
    },
  );
}

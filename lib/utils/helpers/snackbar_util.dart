import 'package:flutter/material.dart';

class SnackbarUtil {
  static void showErrorSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(
      backgroundColor: Colors.redAccent,
      content: Text(message, style: TextStyle(color: Colors.white)),
      dismissDirection: DismissDirection.horizontal,
      duration: Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void showSuccessSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      content: Text(
        message,
        style: Theme.of(context).textTheme.labelLarge,
      ),
      dismissDirection: DismissDirection.horizontal,
      duration: Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

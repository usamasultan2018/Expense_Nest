import 'package:expense_tracker/components/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GoogleButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool loading;
  const GoogleButton({
    required this.onPressed,
    super.key,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 2, // Subtle shadow
        padding: const EdgeInsets.symmetric(horizontal: 16),
        minimumSize: const Size(double.infinity, 54), // Full-width button
      ),
      onPressed: loading ? null : onPressed,
      child: loading
          ? const LoadingWidget()
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  "https://firebasestorage.googleapis.com/v0/b/flutterbricks-public.appspot.com/o/crypto%2Fsearch%20(2).png?alt=media&token=24a918f7-3564-4290-b7e4-08ff54b3c94c",
                  width: 20,
                ),
                const SizedBox(width: 20),
                Text(
                  AppLocalizations.of(context)!.continueWithGoogle,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
    );
  }
}

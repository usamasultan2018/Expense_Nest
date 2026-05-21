import 'package:expense_tracker/core/components/loading_widget.dart';
import 'package:flutter/material.dart';

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
                Image.asset(
                  "assets/images/google.png",
                  width: 20,
                ),
                const SizedBox(width: 20),
                Text(
                  "Continue with google",
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

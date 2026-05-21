import 'package:flutter/material.dart';
import 'package:expense_tracker/core/components/loading_widget.dart';
import 'package:expense_tracker/core/theme/appColors.dart';

class RoundButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final bool loading;
  final double height;
  final double borderRadius;
  final double width;

  const RoundButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.loading = false,
    this.height = 50,
    this.width = double.infinity,
    this.borderRadius = 10,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = loading || onPressed == null;

    return Semantics(
      button: true,
      enabled: !isDisabled,
      label: title,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: isDisabled ? null : onPressed,
          child: Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              gradient: isDisabled
                  ? LinearGradient(
                      colors: [
                        Colors.grey.shade400,
                        Colors.grey.shade500,
                      ],
                    )
                  : AppColors.primaryGradient,
            ),
            child: Center(
              child: loading
                  ? const LoadingWidget()
                  : Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

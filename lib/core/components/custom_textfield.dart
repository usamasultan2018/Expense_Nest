import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final bool obscureText;
  final bool readOnly;
  final bool enabled;
  final IconData? iconData;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final VoidCallback? onTap;
  final int maxLines;
  final int? maxLength;
  final TextInputType textInputType;
  final TextInputAction? textInputAction;
  final Widget? suffixIcon;
  final Widget? prefixIcon; // Allow custom prefix widget
  final EdgeInsetsGeometry? contentPadding;
  final String? errorText;
  final FocusNode? focusNode;
  final TextCapitalization textCapitalization;
  final bool autofocus;

  const CustomTextField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.iconData,
    this.obscureText = false, // Better default naming
    this.readOnly = false,
    this.enabled = true,
    this.onChanged,
    this.validator,
    this.onTap,
    this.maxLines = 1,
    this.maxLength,
    this.textInputType = TextInputType.text,
    this.textInputAction,
    this.suffixIcon,
    this.prefixIcon,
    this.contentPadding,
    this.errorText,
    this.focusNode,
    this.textCapitalization = TextCapitalization.none,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: controller,
      keyboardType: textInputType,
      textInputAction: textInputAction,
      maxLines: obscureText ? 1 : maxLines,
      maxLength: maxLength,
      obscureText: obscureText,
      readOnly: readOnly,
      enabled: enabled,
      onChanged: onChanged,
      validator: validator,
      onTap: onTap,
      focusNode: focusNode,
      textCapitalization: textCapitalization,
      autofocus: autofocus,
      style: TextStyle(
        fontSize: 14,
        color: theme.colorScheme.onSurface,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: !enabled
            ? theme.colorScheme.surface.withValues(alpha: 0.1)
            : readOnly
                ? theme.colorScheme.surface.withValues(alpha: 0.5)
                : theme.colorScheme.surface,
        prefixIcon: prefixIcon ??
            (iconData != null
                ? Icon(
                    iconData,
                    size: 20,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  )
                : null),
        suffixIcon: suffixIcon,
        hintText: hintText,
        labelText: labelText,
        errorText: errorText,
        hintStyle: TextStyle(
          fontSize: 14,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
        ),
        contentPadding: contentPadding ??
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: theme.colorScheme.error,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: theme.colorScheme.error,
            width: 2,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

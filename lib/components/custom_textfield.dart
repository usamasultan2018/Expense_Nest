import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final bool obscureTxt;
  final bool readOnly;
  final IconData iconData;
  final Function(String)? onChanged;
  final int maxLines;
  final TextInputType textInputType;

  const CustomTextField({
    Key? key,
    required this.controller,
    this.hintText,
    required this.iconData,
    required this.obscureTxt,
    this.readOnly = false,
    this.onChanged,
    this.maxLines = 1,
    this.textInputType = TextInputType.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: controller,
      keyboardType: textInputType,
      maxLines: maxLines,
      obscureText: obscureTxt,
      readOnly: readOnly,
      onChanged: onChanged,
      decoration: InputDecoration(
        filled: true,
        fillColor: readOnly
            ? theme.colorScheme.surface.withOpacity(0.1)
            : theme.colorScheme.surface,
        prefixIcon: Icon(
          iconData,
          size: 16,
          color: theme.colorScheme.onSurface.withOpacity(0.6),
        ),
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 14,
          color: theme.colorScheme.onSurface.withOpacity(0.6),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

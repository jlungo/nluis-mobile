import 'package:flutter/material.dart';

class AppInputField extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final bool obscureText;
  final TextInputType keyboardType;
  final bool enabled;
  final int maxLines;
  final EdgeInsetsGeometry contentPadding;
  final Color? fillColor;
  final Color? borderColor;
  final double borderRadius;
  final bool useFormField;

  const AppInputField({
    super.key,
    this.hintText,
    this.labelText,
    this.controller,
    this.onChanged,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.enabled = true,
    this.maxLines = 1,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 12,
    ),
    this.fillColor,
    this.borderColor,
    this.borderRadius = 12,
    this.useFormField = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final inputDecoration = InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
      ),
      prefixIcon:
          prefixIcon != null
              ? Icon(
                prefixIcon,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              )
              : null,
      suffixIcon:
          suffixIcon != null
              ? GestureDetector(
                onTap: onSuffixTap,
                child: Icon(
                  suffixIcon,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              )
              : null,
      filled: true,
      fillColor: fillColor ?? theme.colorScheme.surface,
      contentPadding: contentPadding,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: borderColor ?? Colors.transparent),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: borderColor ?? theme.colorScheme.primary),
      ),
    );

    if (useFormField) {
      return TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        enabled: enabled,
        maxLines: maxLines,
        validator: validator,
        onChanged: onChanged,
        decoration: inputDecoration,
      );
    }

    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      enabled: enabled,
      maxLines: maxLines,
      onChanged: onChanged,
      decoration: inputDecoration,
    );
  }
}

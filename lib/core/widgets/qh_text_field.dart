import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Themed text field used across all QuestHub forms.
class QhTextField extends StatelessWidget {
  const QhTextField({
    required this.label,
    this.controller,
    this.hint,
    this.obscureText = false,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.prefixIcon,
    this.onFieldSubmitted,
    this.textCapitalization = TextCapitalization.none,
    super.key,
  });

  final String label;
  final TextEditingController? controller;
  final String? hint;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final IconData? prefixIcon;
  final void Function(String)? onFieldSubmitted;
  final TextCapitalization textCapitalization;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      autofillHints: autofillHints,
      onFieldSubmitted: onFieldSubmitted,
      textCapitalization: textCapitalization,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon == null
            ? null
            : Icon(prefixIcon, color: AppColors.textSecondary, size: 20),
      ),
    );
  }
}

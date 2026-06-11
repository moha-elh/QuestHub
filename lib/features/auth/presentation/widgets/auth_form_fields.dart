import 'package:flutter/material.dart';

import '../../../../core/widgets/qh_text_field.dart';
import '../auth_validators.dart';

class EmailField extends StatelessWidget {
  const EmailField({required this.controller, this.textInputAction, super.key});

  final TextEditingController controller;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return QhTextField(
      label: 'Email',
      controller: controller,
      validator: AuthValidators.email,
      keyboardType: TextInputType.emailAddress,
      textInputAction: textInputAction ?? TextInputAction.next,
      autofillHints: const [AutofillHints.email],
      prefixIcon: Icons.alternate_email,
    );
  }
}

class PasswordField extends StatelessWidget {
  const PasswordField({
    required this.controller,
    this.label = 'Password',
    this.validator,
    this.textInputAction,
    this.onFieldSubmitted,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return QhTextField(
      label: label,
      controller: controller,
      obscureText: true,
      validator: validator ?? AuthValidators.password,
      textInputAction: textInputAction ?? TextInputAction.done,
      autofillHints: const [AutofillHints.password],
      prefixIcon: Icons.lock_outline,
      onFieldSubmitted: onFieldSubmitted,
    );
  }
}

class UsernameField extends StatelessWidget {
  const UsernameField({required this.controller, super.key});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return QhTextField(
      label: 'Username',
      controller: controller,
      validator: AuthValidators.username,
      textInputAction: TextInputAction.next,
      autofillHints: const [AutofillHints.newUsername],
      prefixIcon: Icons.person_outline,
    );
  }
}

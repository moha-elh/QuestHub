import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/qh_button.dart';
import '../providers/auth_controller.dart';

class GoogleSignInButton extends ConsumerWidget {
  const GoogleSignInButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authControllerProvider).isLoading;

    return QhButton(
      label: 'Continue with Google',
      variant: QhButtonVariant.secondary,
      // Spinner is shown by the email submit button; here we just disable.
      onPressed: isLoading
          ? null
          : () => ref.read(authControllerProvider.notifier).signInWithGoogle(),
      icon: const Text('G', style: TextStyle(fontWeight: FontWeight.w800)),
    );
  }
}

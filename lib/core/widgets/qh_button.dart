import 'package:flutter/material.dart';

enum QhButtonVariant { primary, secondary }

/// Standard QuestHub button with a built-in loading state.
///
/// While [isLoading] is true the button is disabled and shows a spinner,
/// preventing double-submits.
class QhButton extends StatelessWidget {
  const QhButton({
    required this.label,
    required this.onPressed,
    this.variant = QhButtonVariant.primary,
    this.isLoading = false,
    this.icon,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final QhButtonVariant variant;
  final bool isLoading;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final child = isLoading
        ? const SizedBox.square(
            dimension: 22,
            child: CircularProgressIndicator(strokeWidth: 2.5),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[icon!, const SizedBox(width: 8)],
              Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
            ],
          );

    final effectiveOnPressed = isLoading ? null : onPressed;

    return switch (variant) {
      QhButtonVariant.primary =>
        ElevatedButton(onPressed: effectiveOnPressed, child: child),
      QhButtonVariant.secondary =>
        OutlinedButton(onPressed: effectiveOnPressed, child: child),
    };
  }
}

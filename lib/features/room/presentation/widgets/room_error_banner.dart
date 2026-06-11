import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/qh_error_banner.dart';
import '../../domain/room_repository.dart';
import '../providers/room_controller.dart';

/// Surfaces the latest room action error, if any.
class RoomErrorBanner extends ConsumerWidget {
  const RoomErrorBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final error = ref.watch(roomControllerProvider).error;

    final message = switch (error) {
      null => null,
      final RoomException e => e.message,
      _ => 'Something went wrong. Please try again.',
    };

    return QhErrorBanner(message: message);
  }
}

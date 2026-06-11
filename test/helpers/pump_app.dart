import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:questhub/core/theme/app_theme.dart';

// ignore: implementation_imports
import 'package:riverpod/src/framework.dart' show Override;

/// Pumps [widget] inside a ProviderScope + themed MaterialApp, mirroring the
/// real app shell. Pass [overrides] to mock providers (e.g. the auth repo).
extension PumpApp on WidgetTester {
  Future<void> pumpApp(
    Widget widget, {
    List<Override> overrides = const [],
  }) {
    return pumpWidget(
      ProviderScope(
        overrides: overrides,
        child: MaterialApp(
          theme: AppTheme.dark,
          home: widget,
        ),
      ),
    );
  }
}

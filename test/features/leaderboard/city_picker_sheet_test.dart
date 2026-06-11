import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:questhub/features/leaderboard/presentation/widgets/city_picker_sheet.dart';

import '../../helpers/pump_app.dart';

void main() {
  group('CityPickerSheet', () {
    testWidgets('shows title when rendered', (tester) async {
      await tester.pumpApp(
        CityPickerSheet(
          onCitySelected: (_) {},
        ),
      );

      expect(find.text('Select your city'), findsOneWidget);
    });

    testWidgets('filters cities based on search input', (tester) async {
      await tester.pumpApp(
        CityPickerSheet(
          onCitySelected: (_) {},
        ),
      );

      await tester.enterText(find.byType(TextField), 'New');
      await tester.pump();

      expect(find.text('New York'), findsOneWidget);
      expect(find.text('Paris'), findsNothing);
    });

    testWidgets('shows current city with checkmark', (tester) async {
      await tester.pumpApp(
        CityPickerSheet(
          onCitySelected: (_) {},
          currentCity: 'Casablanca',
        ),
      );

      expect(find.text('Current'), findsOneWidget);
    });

    testWidgets('shows no results text when no city matches', (tester) async {
      await tester.pumpApp(
        CityPickerSheet(
          onCitySelected: (_) {},
        ),
      );

      await tester.enterText(find.byType(TextField), 'NonExistentCity123');
      await tester.pump();

      expect(
        find.textContaining('No cities found matching'),
        findsOneWidget,
      );
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:questhub/features/leaderboard/data/city_service.dart';

void main() {
  group('CityService.normalizeCityCode', () {
    test('handles accents correctly', () {
      expect(CityService.normalizeCityCode('Tánger'), equals('tanger'));
    });

    test('handles spaces correctly', () {
      expect(
        CityService.normalizeCityCode('New York'),
        equals('newyork'),
      );
    });

    test('handles mixed case correctly', () {
      expect(CityService.normalizeCityCode('PARIS'), equals('paris'));
    });

    test('handles multiple spaces and accents', () {
      expect(
        CityService.normalizeCityCode('São Paulo'),
        equals('saopaulo'),
      );
    });

    test('handles already clean input', () {
      expect(CityService.normalizeCityCode('casablanca'), equals('casablanca'));
    });

    test('handles empty string', () {
      expect(CityService.normalizeCityCode(''), equals(''));
    });
  });
}

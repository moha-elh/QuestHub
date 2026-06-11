import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CityService {
  CityService();

  static const _prefsCity = 'city_name';
  static const _prefsCityCode = 'city_code';

  /// Detects the user's city using device location + reverse geocoding.
  /// Returns the city name, or null if permission denied / unavailable.
  Future<String?> detectCity() async {
    final status = await Geolocator.requestPermission();
    if (status == LocationPermission.deniedForever ||
        status == LocationPermission.denied) {
      return null;
    }

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.low,
        timeLimit: Duration(seconds: 10),
      ),
    );
    final placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    if (placemarks.isEmpty) return null;

    final locality = placemarks.first.locality;
    if (locality != null && locality.isNotEmpty) return locality;

    // Fallback to sub-administrative area if locality is missing.
    final subLocality = placemarks.first.subAdministrativeArea;
    if (subLocality != null && subLocality.isNotEmpty) return subLocality;

    return placemarks.first.administrativeArea;
  }

  /// Persists the chosen city both to shared_preferences and returns the
  /// normalized cityCode.
  Future<String> setCity(String cityName) async {
    final code = normalizeCityCode(cityName);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsCity, cityName);
    await prefs.setString(_prefsCityCode, code);
    return code;
  }

  /// Returns the cached city code from shared_preferences, or null.
  Future<String?> getCachedCityCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_prefsCityCode);
  }

  /// Returns the cached city name from shared_preferences, or null.
  Future<String?> getCachedCityName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_prefsCity);
  }

  static final _accentMap = <String, String>{
    'à': 'a', 'á': 'a', 'â': 'a', 'ã': 'a', 'ä': 'a', 'å': 'a',
    'è': 'e', 'é': 'e', 'ê': 'e', 'ë': 'e',
    'ì': 'i', 'í': 'i', 'î': 'i', 'ï': 'i',
    'ò': 'o', 'ó': 'o', 'ô': 'o', 'õ': 'o', 'ö': 'o',
    'ù': 'u', 'ú': 'u', 'û': 'u', 'ü': 'u',
    'ñ': 'n', 'ç': 'c', 'ý': 'y',
  };

  /// Normalizes a city name to a code: lowercase, no accents, no spaces.
  static String normalizeCityCode(String name) {
    var result = name.toLowerCase();
    for (final entry in _accentMap.entries) {
      result = result.replaceAll(entry.key, entry.value);
    }
    result = result.replaceAll(RegExp(r'[^a-z0-9]'), '');
    return result;
  }
}

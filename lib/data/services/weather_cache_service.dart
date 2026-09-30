import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/weather_data.dart';

/// Persists the last successful response so the app is useful offline.
class WeatherCacheService {
  WeatherCacheService(this._prefs);

  final SharedPreferences _prefs;
  static const _key = 'last_weather_v1';

  Future<void> save(WeatherData data) =>
      _prefs.setString(_key, jsonEncode(data.toJson()));

  WeatherData? read() {
    final raw = _prefs.getString(_key);
    if (raw == null) return null;
    try {
      return WeatherData.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      _prefs.remove(_key); // corrupt / outdated cache: drop it
      return null;
    }
  }
}

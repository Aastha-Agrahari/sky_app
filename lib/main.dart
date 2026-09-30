import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'data/repositories/weather_repository.dart';
import 'data/services/location_service.dart';
import 'data/services/weather_api_service.dart';
import 'data/services/weather_cache_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Composition root: the only place where concrete dependencies are wired.
  final prefs = await SharedPreferences.getInstance();
  final repository = WeatherRepository(
    api: WeatherApiService(),
    location: LocationService(),
    cache: WeatherCacheService(prefs),
  );

  runApp(SkycastApp(repository: repository));
}

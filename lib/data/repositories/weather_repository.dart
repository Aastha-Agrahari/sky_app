import '../models/city.dart';
import '../models/weather_data.dart';
import '../services/location_service.dart';
import '../services/weather_api_service.dart';
import '../services/weather_cache_service.dart';

/// Single source of truth for weather data. The UI layer only talks to this,
/// never to the API, GPS or storage directly.
class WeatherRepository {
  WeatherRepository({
    required WeatherApiService api,
    required LocationService location,
    required WeatherCacheService cache,
  })  : _api = api,
        _location = location,
        _cache = cache;

  final WeatherApiService _api;
  final LocationService _location;
  final WeatherCacheService _cache;

  /// Shown on first launch when nothing is cached yet.
  static const City defaultCity = City(
    name: 'Mumbai',
    admin1: 'Maharashtra',
    country: 'India',
    latitude: 19.0760,
    longitude: 72.8777,
  );

  WeatherData? getCachedWeather() => _cache.read();

  Future<WeatherData> getWeather(City city) async {
    final data = await _api.fetchWeather(city);
    await _cache.save(data); // only successful responses are cached
    return data;
  }

  Future<WeatherData> getWeatherForCurrentLocation() async {
    final city = await _location.getCurrentCity();
    return getWeather(city);
  }

  Future<List<City>> searchCities(String query) => _api.searchCities(query);
}

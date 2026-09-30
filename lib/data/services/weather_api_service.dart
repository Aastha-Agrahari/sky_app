import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../core/constants/api_constants.dart';
import '../../core/errors/app_exception.dart';
import '../models/city.dart';
import '../models/weather_data.dart';

/// Talks to Open-Meteo (forecast + geocoding). No API key required.
/// Its only job: make HTTP calls and translate failures into [AppException].
class WeatherApiService {
  WeatherApiService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<WeatherData> fetchWeather(City city) async {
    final uri = Uri.https(ApiConstants.forecastHost, '/v1/forecast', {
      'latitude': city.latitude.toString(),
      'longitude': city.longitude.toString(),
      'current': 'temperature_2m,relative_humidity_2m,apparent_temperature,'
          'is_day,weather_code,wind_speed_10m,pressure_msl,precipitation',
      'hourly': 'temperature_2m,weather_code,is_day',
      'daily': 'weather_code,temperature_2m_max,temperature_2m_min,'
          'precipitation_probability_max',
      'timezone': 'auto',
      'forecast_days': '7',
    });

    final json = await _getJson(uri);
    try {
      return WeatherData.fromApi(city, json);
    } catch (_) {
      throw const AppException(
        AppErrorType.unknown,
        'Received an unexpected response from the weather service.',
      );
    }
  }

  Future<List<City>> searchCities(String query) async {
    final uri = Uri.https(ApiConstants.geocodingHost, '/v1/search', {
      'name': query,
      'count': '8',
      'language': 'en',
      'format': 'json',
    });

    final json = await _getJson(uri);
    final results = json['results'] as List?; // key is absent when no match
    if (results == null) return const [];
    return results
        .map((e) => City.fromGeocoding(e as Map<String, dynamic>))
        .toList();
  }

  Future<Map<String, dynamic>> _getJson(Uri uri) async {
    try {
      final response = await _client.get(uri).timeout(ApiConstants.timeout);

      if (response.statusCode == 429) {
        throw const AppException(
          AppErrorType.rateLimit,
          'Too many requests. Please wait a moment and try again.',
        );
      }
      if (response.statusCode >= 500) {
        throw const AppException(
          AppErrorType.server,
          'The weather service is having trouble. Please try again later.',
        );
      }
      if (response.statusCode != 200) {
        throw AppException(
          AppErrorType.unknown,
          'Unexpected response (${response.statusCode}).',
        );
      }
      return jsonDecode(response.body) as Map<String, dynamic>;
    } on SocketException {
      throw const AppException(
        AppErrorType.noInternet,
        'No internet connection. Check your network and try again.',
      );
    } on http.ClientException {
      throw const AppException(
        AppErrorType.noInternet,
        'No internet connection. Check your network and try again.',
      );
    } on TimeoutException {
      throw const AppException(
        AppErrorType.timeout,
        'The request took too long. Please try again.',
      );
    } on FormatException {
      throw const AppException(
        AppErrorType.unknown,
        'Received an unreadable response from the server.',
      );
    }
  }
}

import 'city.dart';
import 'current_weather.dart';
import 'daily_forecast.dart';
import 'hourly_forecast.dart';

/// Everything the weather screen needs for one city, at one point in time.
class WeatherData {
  const WeatherData({
    required this.city,
    required this.current,
    required this.hourly,
    required this.daily,
    required this.fetchedAt,
  });

  final City city;
  final CurrentWeather current;
  final List<HourlyForecast> hourly;
  final List<DailyForecast> daily;
  final DateTime fetchedAt;

  /// Maps the raw Open-Meteo response into our own models, so the rest of the
  /// app never depends on the API's JSON shape.
  factory WeatherData.fromApi(City city, Map<String, dynamic> json) {
    final current = CurrentWeather.fromApi(
      json['current'] as Map<String, dynamic>,
    );

    final h = json['hourly'] as Map<String, dynamic>;
    final hTimes = (h['time'] as List).cast<String>();
    final hTemps = h['temperature_2m'] as List;
    final hCodes = h['weather_code'] as List;
    final hDay = h['is_day'] as List;
    final startOfHour = DateTime(
      current.time.year,
      current.time.month,
      current.time.day,
      current.time.hour,
    );
    final hourly = <HourlyForecast>[
      for (var i = 0; i < hTimes.length; i++)
        HourlyForecast(
          time: DateTime.parse(hTimes[i]),
          temperature: (hTemps[i] as num).toDouble(),
          weatherCode: (hCodes[i] as num).toInt(),
          isDay: (hDay[i] as num) == 1,
        ),
    ].where((e) => !e.time.isBefore(startOfHour)).take(24).toList();

    final d = json['daily'] as Map<String, dynamic>;
    final dTimes = (d['time'] as List).cast<String>();
    final dCodes = d['weather_code'] as List;
    final dMax = d['temperature_2m_max'] as List;
    final dMin = d['temperature_2m_min'] as List;
    final dRain = d['precipitation_probability_max'] as List;
    final daily = <DailyForecast>[
      for (var i = 0; i < dTimes.length; i++)
        DailyForecast(
          date: DateTime.parse(dTimes[i]),
          weatherCode: (dCodes[i] as num).toInt(),
          tempMax: (dMax[i] as num).toDouble(),
          tempMin: (dMin[i] as num).toDouble(),
          precipitationChance: (dRain[i] as num?)?.toInt() ?? 0,
        ),
    ];

    return WeatherData(
      city: city,
      current: current,
      hourly: hourly,
      daily: daily,
      fetchedAt: DateTime.now(),
    );
  }

  factory WeatherData.fromJson(Map<String, dynamic> json) => WeatherData(
        city: City.fromJson(json['city'] as Map<String, dynamic>),
        current: CurrentWeather.fromJson(json['current'] as Map<String, dynamic>),
        hourly: (json['hourly'] as List)
            .map((e) => HourlyForecast.fromJson(e as Map<String, dynamic>))
            .toList(),
        daily: (json['daily'] as List)
            .map((e) => DailyForecast.fromJson(e as Map<String, dynamic>))
            .toList(),
        fetchedAt: DateTime.parse(json['fetchedAt'] as String),
      );

  Map<String, dynamic> toJson() => {
        'city': city.toJson(),
        'current': current.toJson(),
        'hourly': hourly.map((e) => e.toJson()).toList(),
        'daily': daily.map((e) => e.toJson()).toList(),
        'fetchedAt': fetchedAt.toIso8601String(),
      };
}

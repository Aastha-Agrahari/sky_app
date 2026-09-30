class CurrentWeather {
  const CurrentWeather({
    required this.time,
    required this.temperature,
    required this.apparentTemperature,
    required this.humidity,
    required this.windSpeed,
    required this.pressure,
    required this.precipitation,
    required this.weatherCode,
    required this.isDay,
  });

  final DateTime time;
  final double temperature;
  final double apparentTemperature;
  final int humidity;
  final double windSpeed;
  final double pressure;
  final double precipitation;
  final int weatherCode;
  final bool isDay;

  factory CurrentWeather.fromApi(Map<String, dynamic> json) => CurrentWeather(
        time: DateTime.parse(json['time'] as String),
        temperature: (json['temperature_2m'] as num).toDouble(),
        apparentTemperature: (json['apparent_temperature'] as num).toDouble(),
        humidity: (json['relative_humidity_2m'] as num).toInt(),
        windSpeed: (json['wind_speed_10m'] as num).toDouble(),
        pressure: (json['pressure_msl'] as num).toDouble(),
        precipitation: (json['precipitation'] as num).toDouble(),
        weatherCode: (json['weather_code'] as num).toInt(),
        isDay: (json['is_day'] as num) == 1,
      );

  factory CurrentWeather.fromJson(Map<String, dynamic> json) => CurrentWeather(
        time: DateTime.parse(json['time'] as String),
        temperature: (json['temperature'] as num).toDouble(),
        apparentTemperature: (json['apparentTemperature'] as num).toDouble(),
        humidity: json['humidity'] as int,
        windSpeed: (json['windSpeed'] as num).toDouble(),
        pressure: (json['pressure'] as num).toDouble(),
        precipitation: (json['precipitation'] as num).toDouble(),
        weatherCode: json['weatherCode'] as int,
        isDay: json['isDay'] as bool,
      );

  Map<String, dynamic> toJson() => {
        'time': time.toIso8601String(),
        'temperature': temperature,
        'apparentTemperature': apparentTemperature,
        'humidity': humidity,
        'windSpeed': windSpeed,
        'pressure': pressure,
        'precipitation': precipitation,
        'weatherCode': weatherCode,
        'isDay': isDay,
      };
}

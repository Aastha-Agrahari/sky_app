import 'package:flutter/material.dart';

import '../../../core/utils/formatters.dart';
import '../../../core/utils/weather_condition.dart';
import '../../../data/models/weather_data.dart';
import 'floating_weather_icon.dart';

/// The headline block: icon, big temperature, condition and today's range.
class CurrentWeatherHero extends StatelessWidget {
  const CurrentWeatherHero({super.key, required this.weather});

  final WeatherData weather;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final current = weather.current;
    final today = weather.daily.isEmpty ? null : weather.daily.first;
    final condition = WeatherCondition.fromCode(current.weatherCode);

    final details = StringBuffer(
      'Feels like ${Formatters.temp(current.apparentTemperature)}',
    );
    if (today != null) {
      details.write(
        '   •   H ${Formatters.temp(today.tempMax)}   L ${Formatters.temp(today.tempMin)}',
      );
    }

    return Column(
      children: [
        FloatingWeatherIcon(condition: condition, isDay: current.isDay),
        Text(
          Formatters.temp(current.temperature),
          style: const TextStyle(
            fontSize: 96,
            fontWeight: FontWeight.w200,
            height: 1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          condition.label,
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        Text(
          details.toString(),
          style: textTheme.bodyMedium?.copyWith(
            color: Colors.white.withValues(alpha: 0.85),
          ),
        ),
      ],
    );
  }
}

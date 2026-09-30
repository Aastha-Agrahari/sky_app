import 'package:flutter/material.dart';

import '../../../core/utils/formatters.dart';
import '../../../data/models/weather_data.dart';
import 'current_weather_hero.dart';
import 'daily_forecast_list.dart';
import 'hourly_forecast_list.dart';
import 'stale_data_banner.dart';
import 'weather_details_grid.dart';

/// Scrollable success state. Always scrollable so pull-to-refresh works
/// even when the content is shorter than the screen.
class WeatherContent extends StatelessWidget {
  const WeatherContent({
    super.key,
    required this.weather,
    required this.isStale,
    required this.onRetry,
  });

  final WeatherData weather;
  final bool isStale;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final rainChance =
        weather.daily.isEmpty ? 0 : weather.daily.first.precipitationChance;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      children: [
        if (isStale) ...[
          StaleDataBanner(lastUpdated: weather.fetchedAt, onRetry: onRetry),
          const SizedBox(height: 16),
        ],
        CurrentWeatherHero(weather: weather),
        const SizedBox(height: 28),
        WeatherDetailsGrid(current: weather.current, rainChance: rainChance),
        const SizedBox(height: 16),
        HourlyForecastList(hours: weather.hourly),
        const SizedBox(height: 16),
        DailyForecastList(days: weather.daily),
        const SizedBox(height: 20),
        Center(
          child: Text(
            'Updated ${Formatters.clock(weather.fetchedAt)}  •  Data by Open-Meteo',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.6),
                ),
          ),
        ),
      ],
    );
  }
}

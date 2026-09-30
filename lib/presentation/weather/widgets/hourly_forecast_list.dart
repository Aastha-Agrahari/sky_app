import 'package:flutter/material.dart';

import '../../../core/utils/formatters.dart';
import '../../../core/utils/weather_condition.dart';
import '../../../data/models/hourly_forecast.dart';
import 'glass_card.dart';

class HourlyForecastList extends StatelessWidget {
  const HourlyForecastList({super.key, required this.hours});

  final List<HourlyForecast> hours;

  @override
  Widget build(BuildContext context) {
    if (hours.isEmpty) return const SizedBox.shrink();

    return GlassCard(
      title: 'Next 24 hours',
      titleIcon: Icons.schedule_rounded,
      child: SizedBox(
        height: 104,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: hours.length,
          separatorBuilder: (_, __) => const SizedBox(width: 18),
          itemBuilder: (context, index) {
            final hour = hours[index];
            final condition = WeatherCondition.fromCode(hour.weatherCode);
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  index == 0 ? 'Now' : Formatters.hour(hour.time),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                ),
                Icon(
                  condition.icon(hour.isDay),
                  size: 28,
                  color: condition.iconColor(hour.isDay),
                ),
                Text(
                  Formatters.temp(hour.temperature),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

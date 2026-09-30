import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/utils/formatters.dart';
import '../../../core/utils/weather_condition.dart';
import '../../../data/models/daily_forecast.dart';
import 'glass_card.dart';

class DailyForecastList extends StatelessWidget {
  const DailyForecastList({super.key, required this.days});

  final List<DailyForecast> days;

  @override
  Widget build(BuildContext context) {
    if (days.isEmpty) return const SizedBox.shrink();

    final weekMin = days.map((d) => d.tempMin).reduce(math.min);
    final weekMax = days.map((d) => d.tempMax).reduce(math.max);

    return GlassCard(
      title: '7-day forecast',
      titleIcon: Icons.calendar_month_rounded,
      child: Column(
        children: [
          for (var i = 0; i < days.length; i++)
            _DailyRow(
              day: days[i],
              isToday: i == 0,
              weekMin: weekMin,
              weekMax: weekMax,
            ),
        ],
      ),
    );
  }
}

class _DailyRow extends StatelessWidget {
  const _DailyRow({
    required this.day,
    required this.isToday,
    required this.weekMin,
    required this.weekMax,
  });

  final DailyForecast day;
  final bool isToday;
  final double weekMin;
  final double weekMax;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final condition = WeatherCondition.fromCode(day.weatherCode);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 56,
            child: Text(
              isToday ? 'Today' : Formatters.weekday(day.date),
              style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          Icon(condition.icon(true), size: 24, color: condition.iconColor(true)),
          SizedBox(
            width: 46,
            child: Text(
              day.precipitationChance > 0 ? '${day.precipitationChance}%' : '',
              textAlign: TextAlign.center,
              style: textTheme.bodySmall?.copyWith(
                color: const Color(0xFF9BE7FF),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Spacer(),
          SizedBox(
            width: 34,
            child: Text(
              Formatters.temp(day.tempMin),
              textAlign: TextAlign.end,
              style: textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
          ),
          const SizedBox(width: 8),
          _RangeBar(
            min: day.tempMin,
            max: day.tempMax,
            weekMin: weekMin,
            weekMax: weekMax,
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 34,
            child: Text(
              Formatters.temp(day.tempMax),
              style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

/// Shows where a day's min–max sits inside the whole week's range.
class _RangeBar extends StatelessWidget {
  const _RangeBar({
    required this.min,
    required this.max,
    required this.weekMin,
    required this.weekMax,
  });

  final double min;
  final double max;
  final double weekMin;
  final double weekMax;

  @override
  Widget build(BuildContext context) {
    final span = math.max(1.0, weekMax - weekMin);
    final startFraction = (min - weekMin) / span;
    final endFraction = (max - weekMin) / span;

    return SizedBox(
      width: 80,
      height: 6,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final total = constraints.maxWidth;
          final width = math.max(6.0, total * (endFraction - startFraction));
          final left = math.min(total * startFraction, total - width);
          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              Positioned(
                left: left,
                width: width,
                top: 0,
                bottom: 0,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF7DD3FC), Color(0xFFFFD54F)],
                    ),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';

/// Maps WMO weather codes (used by Open-Meteo) to a label, icon and palette.
class WeatherCondition {
  const WeatherCondition._({
    required this.label,
    required this.dayIcon,
    required this.nightIcon,
    required this.dayGradient,
    required this.nightGradient,
  });

  final String label;
  final IconData dayIcon;
  final IconData nightIcon;
  final List<Color> dayGradient;
  final List<Color> nightGradient;

  IconData icon(bool isDay) => isDay ? dayIcon : nightIcon;
  List<Color> gradient(bool isDay) => isDay ? dayGradient : nightGradient;

  Color iconColor(bool isDay) {
    if (dayIcon == Icons.wb_sunny_rounded) {
      return isDay ? const Color(0xFFFFD54F) : const Color(0xFFFFF3C4);
    }
    return Colors.white;
  }

  static const _clear = WeatherCondition._(
    label: 'Clear sky',
    dayIcon: Icons.wb_sunny_rounded,
    nightIcon: Icons.nightlight_round,
    dayGradient: [Color(0xFF2F80ED), Color(0xFF56CCF2)],
    nightGradient: [Color(0xFF0B1026), Color(0xFF2B3A67)],
  );
  static const _mainlyClear = WeatherCondition._(
    label: 'Mainly clear',
    dayIcon: Icons.wb_sunny_rounded,
    nightIcon: Icons.nightlight_round,
    dayGradient: [Color(0xFF2F80ED), Color(0xFF56CCF2)],
    nightGradient: [Color(0xFF0B1026), Color(0xFF2B3A67)],
  );
  static const _partlyCloudy = WeatherCondition._(
    label: 'Partly cloudy',
    dayIcon: Icons.cloud_queue_rounded,
    nightIcon: Icons.nights_stay_rounded,
    dayGradient: [Color(0xFF4B79A1), Color(0xFF83A4D4)],
    nightGradient: [Color(0xFF1C2541), Color(0xFF3A506B)],
  );
  static const _overcast = WeatherCondition._(
    label: 'Overcast',
    dayIcon: Icons.cloud_rounded,
    nightIcon: Icons.cloud_rounded,
    dayGradient: [Color(0xFF606C88), Color(0xFF3F4C6B)],
    nightGradient: [Color(0xFF232B3A), Color(0xFF3B4558)],
  );
  static const _fog = WeatherCondition._(
    label: 'Foggy',
    dayIcon: Icons.blur_on_rounded,
    nightIcon: Icons.blur_on_rounded,
    dayGradient: [Color(0xFF6B7A8F), Color(0xFF9FB1C4)],
    nightGradient: [Color(0xFF2E3440), Color(0xFF4C566A)],
  );
  static const _drizzle = WeatherCondition._(
    label: 'Drizzle',
    dayIcon: Icons.grain_rounded,
    nightIcon: Icons.grain_rounded,
    dayGradient: [Color(0xFF5B7B93), Color(0xFF3A5568)],
    nightGradient: [Color(0xFF141E30), Color(0xFF243B55)],
  );
  static const _rain = WeatherCondition._(
    label: 'Rain',
    dayIcon: Icons.umbrella_rounded,
    nightIcon: Icons.umbrella_rounded,
    dayGradient: [Color(0xFF485563), Color(0xFF29323C)],
    nightGradient: [Color(0xFF141E30), Color(0xFF243B55)],
  );
  static const _showers = WeatherCondition._(
    label: 'Rain showers',
    dayIcon: Icons.umbrella_rounded,
    nightIcon: Icons.umbrella_rounded,
    dayGradient: [Color(0xFF485563), Color(0xFF29323C)],
    nightGradient: [Color(0xFF141E30), Color(0xFF243B55)],
  );
  static const _snow = WeatherCondition._(
    label: 'Snow',
    dayIcon: Icons.ac_unit_rounded,
    nightIcon: Icons.ac_unit_rounded,
    dayGradient: [Color(0xFF6C8EBF), Color(0xFF9DB9DC)],
    nightGradient: [Color(0xFF283048), Color(0xFF485563)],
  );
  static const _thunderstorm = WeatherCondition._(
    label: 'Thunderstorm',
    dayIcon: Icons.thunderstorm_rounded,
    nightIcon: Icons.thunderstorm_rounded,
    dayGradient: [Color(0xFF2C3E50), Color(0xFF4B3F72)],
    nightGradient: [Color(0xFF0F0C29), Color(0xFF302B63)],
  );
  static const _unknown = WeatherCondition._(
    label: 'Unknown',
    dayIcon: Icons.cloud_rounded,
    nightIcon: Icons.cloud_rounded,
    dayGradient: [Color(0xFF606C88), Color(0xFF3F4C6B)],
    nightGradient: [Color(0xFF232B3A), Color(0xFF3B4558)],
  );

  static WeatherCondition fromCode(int code) => switch (code) {
        0 => _clear,
        1 => _mainlyClear,
        2 => _partlyCloudy,
        3 => _overcast,
        45 || 48 => _fog,
        >= 51 && <= 57 => _drizzle,
        >= 61 && <= 67 => _rain,
        >= 71 && <= 77 => _snow,
        >= 80 && <= 82 => _showers,
        85 || 86 => _snow,
        >= 95 && <= 99 => _thunderstorm,
        _ => _unknown,
      };

  /// Background used before any weather data is available.
  static const List<Color> defaultGradient = [
    Color(0xFF2F80ED),
    Color(0xFF56CCF2),
  ];
}

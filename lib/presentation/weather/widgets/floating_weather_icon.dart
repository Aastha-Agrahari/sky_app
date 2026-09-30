import 'package:flutter/material.dart';

import '../../../core/utils/weather_condition.dart';

/// Large weather "illustration": a glowing icon that gently floats.
class FloatingWeatherIcon extends StatefulWidget {
  const FloatingWeatherIcon({
    super.key,
    required this.condition,
    required this.isDay,
    this.size = 120,
  });

  final WeatherCondition condition;
  final bool isDay;
  final double size;

  @override
  State<FloatingWeatherIcon> createState() => _FloatingWeatherIconState();
}

class _FloatingWeatherIconState extends State<FloatingWeatherIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  )..repeat(reverse: true);

  late final Animation<double> _float = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOut,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.condition.iconColor(widget.isDay);
    final icon = widget.condition.icon(widget.isDay);

    return AnimatedBuilder(
      animation: _float,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, -12 * _float.value),
        child: child,
      ),
      child: SizedBox(
        width: widget.size * 1.8,
        height: widget.size * 1.5,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: widget.size * 1.6,
              height: widget.size * 1.6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    color.withValues(alpha: 0.32),
                    color.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: Icon(
                icon,
                key: ValueKey(icon),
                size: widget.size,
                color: color,
                shadows: [
                  Shadow(color: color.withValues(alpha: 0.5), blurRadius: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

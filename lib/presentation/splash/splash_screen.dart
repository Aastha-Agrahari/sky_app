import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/utils/weather_condition.dart';
import '../weather/weather_screen.dart';
import '../weather/weather_view_model.dart';

/// Branded launch screen. While the animation plays, the view model is already
/// loading cached / fresh data so the weather screen often appears ready.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  )..forward();

  late final Animation<double> _iconScale = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0, 0.65, curve: Curves.elasticOut),
  );
  late final Animation<double> _textFade = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.5, 1, curve: Curves.easeOut),
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<WeatherViewModel>().init();
    });
    _goToWeather();
  }

  Future<void> _goToWeather() async {
    await Future<void>.delayed(const Duration(milliseconds: 2600));
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 900),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const WeatherScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          );
          return FadeTransition(
            opacity: curved,
            child: ScaleTransition(
              scale: Tween<double>(begin: 1.05, end: 1).animate(curved),
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: WeatherCondition.defaultGradient,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _iconScale,
              child: SizedBox(
                width: 160,
                height: 130,
                child: Stack(
                  alignment: Alignment.center,
                  children: const [
                    Positioned(
                      top: 0,
                      right: 14,
                      child: Icon(
                        Icons.wb_sunny_rounded,
                        size: 76,
                        color: Color(0xFFFFD54F),
                        shadows: [
                          Shadow(color: Color(0x99FFD54F), blurRadius: 30),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 6,
                      child: Icon(
                        Icons.cloud_rounded,
                        size: 104,
                        color: Colors.white,
                        shadows: [
                          Shadow(color: Color(0x55000000), blurRadius: 24),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 28),
            FadeTransition(
              opacity: _textFade,
              child: Column(
                children: [
                  Text(
                    'SKYCAST',
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.w300,
                      letterSpacing: 10,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Weather, beautifully simple',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.8),
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'data/repositories/weather_repository.dart';
import 'presentation/splash/splash_screen.dart';
import 'presentation/weather/weather_view_model.dart';

class SkycastApp extends StatelessWidget {
  const SkycastApp({super.key, required this.repository});

  final WeatherRepository repository;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<WeatherRepository>.value(value: repository),
        ChangeNotifierProvider(create: (_) => WeatherViewModel(repository)),
      ],
      child: MaterialApp(
        title: 'Skycast',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        home: const SplashScreen(),
      ),
    );
  }
}

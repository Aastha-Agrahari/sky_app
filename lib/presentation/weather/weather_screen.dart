import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../core/utils/weather_condition.dart';
import '../../data/models/city.dart';
import '../../data/repositories/weather_repository.dart';
import '../search/city_search_screen.dart';
import '../search/city_search_view_model.dart';
import 'weather_view_model.dart';
import 'widgets/weather_content.dart';
import 'widgets/weather_error_view.dart';
import 'widgets/weather_header.dart';
import 'widgets/weather_loading_view.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late final StreamSubscription<String> _messageSub;

  @override
  void initState() {
    super.initState();
    _messageSub =
        context.read<WeatherViewModel>().messages.listen(_showMessage);
  }

  @override
  void dispose() {
    _messageSub.cancel();
    super.dispose();
  }

  void _showMessage(String message) {
    if (!mounted) return;
    final vm = context.read<WeatherViewModel>();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          action: SnackBarAction(label: 'Retry', onPressed: vm.retry),
        ),
      );
  }

  Future<void> _openSearch() async {
    final repository = context.read<WeatherRepository>();
    final viewModel = context.read<WeatherViewModel>();
    final city = await Navigator.of(context).push<City>(
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider(
          create: (_) => CitySearchViewModel(repository),
          child: const CitySearchScreen(),
        ),
      ),
    );
    if (city != null) viewModel.selectCity(city);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<WeatherViewModel>();
    final weather = vm.weather;

    final gradient = weather == null
        ? WeatherCondition.defaultGradient
        : WeatherCondition.fromCode(weather.current.weatherCode)
            .gradient(weather.current.isDay);

    final city = weather?.city;
    final title = city == null
        ? 'Skycast'
        : (city.isCurrentLocation ? 'Current location' : city.name);
    final subtitle = city == null
        ? null
        : (city.isCurrentLocation ? 'Based on your GPS' : city.subtitle);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: gradient,
          ),
        ),
        child: Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                WeatherHeader(
                  title: title,
                  subtitle: subtitle,
                  isBusy: vm.isBusy,
                  isRefreshing: vm.isRefreshing,
                  onSearch: _openSearch,
                  onLocate: vm.useCurrentLocation,
                  onRefresh: vm.refresh,
                ),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: _buildBody(vm),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(WeatherViewModel vm) {
    switch (vm.status) {
      case ViewStatus.loading:
        return const WeatherLoadingView(key: ValueKey('loading'));
      case ViewStatus.error:
        return WeatherErrorView(
          key: const ValueKey('error'),
          error: vm.error!,
          onRetry: vm.retry,
          onSearch: _openSearch,
        );
      case ViewStatus.success:
        return RefreshIndicator(
          key: const ValueKey('content'),
          onRefresh: vm.refresh,
          color: const Color(0xFF2F80ED),
          backgroundColor: Colors.white,
          child: WeatherContent(
            weather: vm.weather!,
            isStale: vm.isStale,
            onRetry: vm.retry,
          ),
        );
    }
  }
}

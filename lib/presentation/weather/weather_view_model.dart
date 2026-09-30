import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../core/errors/app_exception.dart';
import '../../data/models/city.dart';
import '../../data/models/weather_data.dart';
import '../../data/repositories/weather_repository.dart';

enum ViewStatus { loading, success, error }

/// Holds the weather screen state and orchestrates loading / refreshing.
///
/// Key rule: once we have data, a failure NEVER replaces it. It only marks the
/// data as stale and emits a one-off message for a snackbar. A full-screen
/// error is shown only when there is nothing at all to display.
class WeatherViewModel extends ChangeNotifier {
  WeatherViewModel(this._repository);

  final WeatherRepository _repository;
  final _messages = StreamController<String>.broadcast();

  ViewStatus _status = ViewStatus.loading;
  WeatherData? _weather;
  AppException? _error;
  bool _isRefreshing = false;
  bool _isStale = false;
  bool _busy = false;
  bool _initialised = false;

  ViewStatus get status => _status;
  WeatherData? get weather => _weather;
  AppException? get error => _error;
  bool get isRefreshing => _isRefreshing;
  bool get isStale => _isStale;
  bool get isBusy => _busy;

  /// One-off user messages (e.g. "refresh failed") for the UI to show.
  Stream<String> get messages => _messages.stream;

  /// Cache-first startup: show saved data instantly, then refresh in background.
  Future<void> init() async {
    if (_initialised) return;
    _initialised = true;

    final cached = _repository.getCachedWeather();
    if (cached != null) {
      _weather = cached;
      _isStale = true; // stale until the first fresh response arrives
      _status = ViewStatus.success;
      notifyListeners();
      await refresh();
    } else {
      await _load(() => _repository.getWeather(WeatherRepository.defaultCity));
    }
  }

  Future<void> refresh() {
    final current = _weather;
    if (current == null) return retry();
    return _load(
      () => current.city.isCurrentLocation
          ? _repository.getWeatherForCurrentLocation()
          : _repository.getWeather(current.city),
      isRefresh: true,
    );
  }

  Future<void> retry() {
    if (_weather == null) {
      return _load(() => _repository.getWeather(WeatherRepository.defaultCity));
    }
    return refresh();
  }

  Future<void> selectCity(City city) =>
      _load(() => _repository.getWeather(city));

  Future<void> useCurrentLocation() =>
      _load(_repository.getWeatherForCurrentLocation);

  Future<void> _load(
    Future<WeatherData> Function() request, {
    bool isRefresh = false,
  }) async {
    if (_busy) return; // ignore taps while a request is in flight
    _busy = true;
    _error = null;

    if (isRefresh) {
      _isRefreshing = true; // keep content on screen, just show progress
    } else {
      _status = ViewStatus.loading;
    }
    notifyListeners();

    try {
      _weather = await request();
      _isStale = false;
      _status = ViewStatus.success;
    } on AppException catch (e) {
      _handleFailure(e);
    } catch (_) {
      _handleFailure(
        const AppException(AppErrorType.unknown, 'Something went wrong.'),
      );
    } finally {
      _busy = false;
      _isRefreshing = false;
      notifyListeners();
    }
  }

  void _handleFailure(AppException e) {
    if (_weather != null) {
      // Keep previous data visible; flag it as stale and tell the user why.
      _status = ViewStatus.success;
      _isStale = true;
      _messages.add(e.message);
    } else {
      _status = ViewStatus.error;
      _error = e;
    }
  }

  @override
  void dispose() {
    _messages.close();
    super.dispose();
  }
}

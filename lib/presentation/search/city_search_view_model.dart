import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../core/errors/app_exception.dart';
import '../../data/models/city.dart';
import '../../data/repositories/weather_repository.dart';

enum SearchStatus { idle, loading, results, empty, error }

/// Debounced city search. Stale responses are ignored via a request id.
class CitySearchViewModel extends ChangeNotifier {
  CitySearchViewModel(this._repository);

  final WeatherRepository _repository;

  Timer? _debounce;
  int _requestId = 0;
  bool _disposed = false;

  SearchStatus _status = SearchStatus.idle;
  List<City> _results = const [];
  String _query = '';
  String _errorMessage = '';

  SearchStatus get status => _status;
  List<City> get results => _results;
  String get query => _query;
  String get errorMessage => _errorMessage;

  void onQueryChanged(String input) {
    _debounce?.cancel();
    _query = input.trim();

    if (_query.length < 2) {
      _requestId++; // invalidate any in-flight request
      _results = const [];
      _status = SearchStatus.idle;
      notifyListeners();
      return;
    }

    _status = SearchStatus.loading;
    notifyListeners();
    _debounce = Timer(const Duration(milliseconds: 400), _search);
  }

  Future<void> retry() => _search();

  Future<void> _search() async {
    final id = ++_requestId;
    final query = _query;
    try {
      final found = await _repository.searchCities(query);
      if (id != _requestId) return;
      _results = found;
      _status = found.isEmpty ? SearchStatus.empty : SearchStatus.results;
    } on AppException catch (e) {
      if (id != _requestId) return;
      _errorMessage = e.message;
      _status = SearchStatus.error;
    } catch (_) {
      if (id != _requestId) return;
      _errorMessage = 'Something went wrong. Please try again.';
      _status = SearchStatus.error;
    }
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _debounce?.cancel();
    super.dispose();
  }
}

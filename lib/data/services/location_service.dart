import 'dart:async';

import 'package:geolocator/geolocator.dart';

import '../../core/errors/app_exception.dart';
import '../models/city.dart';

/// Wraps the device GPS and hands back a [City] for the current position.
class LocationService {
  Future<City> getCurrentCity() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw const AppException(
        AppErrorType.location,
        'Location services are turned off. Enable GPS and try again.',
      );
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      throw const AppException(
        AppErrorType.location,
        'Location permission was denied.',
      );
    }
    if (permission == LocationPermission.deniedForever) {
      throw const AppException(
        AppErrorType.location,
        'Location permission is permanently denied. Enable it in app settings.',
      );
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
          timeLimit: Duration(seconds: 10),
        ),
      );
      return City(
        name: 'Current location',
        latitude: position.latitude,
        longitude: position.longitude,
        isCurrentLocation: true,
      );
    } on TimeoutException {
      throw const AppException(
        AppErrorType.location,
        'Could not determine your location in time. Try again.',
      );
    }
  }
}

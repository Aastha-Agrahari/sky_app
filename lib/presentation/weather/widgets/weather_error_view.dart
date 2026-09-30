import 'package:flutter/material.dart';

import '../../../core/errors/app_exception.dart';

/// Full-screen error, used only when there is no data at all to show.
class WeatherErrorView extends StatelessWidget {
  const WeatherErrorView({
    super.key,
    required this.error,
    required this.onRetry,
    required this.onSearch,
  });

  final AppException error;
  final VoidCallback onRetry;
  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(error.type.icon, size: 84, color: Colors.white),
            const SizedBox(height: 20),
            Text(
              error.type.title,
              textAlign: TextAlign.center,
              style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              error.message,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.85),
              ),
            ),
            const SizedBox(height: 28),
            FilledButton.icon(
              onPressed: onRetry,
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF1E3A5F),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              ),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try again'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: onSearch,
              style: TextButton.styleFrom(foregroundColor: Colors.white),
              child: const Text('Search another city'),
            ),
          ],
        ),
      ),
    );
  }
}

extension on AppErrorType {
  IconData get icon => switch (this) {
        AppErrorType.noInternet => Icons.wifi_off_rounded,
        AppErrorType.timeout => Icons.timer_off_rounded,
        AppErrorType.rateLimit => Icons.speed_rounded,
        AppErrorType.server => Icons.cloud_off_rounded,
        AppErrorType.location => Icons.location_off_rounded,
        AppErrorType.unknown => Icons.error_outline_rounded,
      };

  String get title => switch (this) {
        AppErrorType.noInternet => 'No internet connection',
        AppErrorType.timeout => 'Request timed out',
        AppErrorType.rateLimit => 'Too many requests',
        AppErrorType.server => 'Weather service unavailable',
        AppErrorType.location => 'Location unavailable',
        AppErrorType.unknown => 'Something went wrong',
      };
}

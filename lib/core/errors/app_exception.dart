enum AppErrorType { noInternet, timeout, rateLimit, server, location, unknown }

/// A domain-level error carrying a user-friendly message.
/// Lower layers translate raw exceptions into this so the UI never sees them.
class AppException implements Exception {
  const AppException(this.type, this.message);

  final AppErrorType type;
  final String message;

  @override
  String toString() => 'AppException($type): $message';
}

class RevenueCatException implements Exception {
  final String message;
  final String? code;
  final Object? originalError;

  const RevenueCatException(
    this.message, {
    this.code,
    this.originalError,
  });

  bool get isCancelled => code == 'CANCELLED';

  @override
  String toString() => 'RevenueCatException($code): $message';
}
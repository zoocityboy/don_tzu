import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

/// Global logger service for the application.
/// Provides a centralized logging solution with configurable levels and handlers.
class AppLogger {
  static final Logger _logger = Logger('ArtOfDealWar');
  static bool _isInitialized = false;

  /// Set the logging level for the application.
  static void setLevel(Level level) {
    Logger.root.level = level;
  }

  /// Get the root logger instance.
  static Logger get logger => _logger;

  /// Log a critical error message.
  static void critical(
    String message, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    _logger.shout(message, error, stackTrace);
  }

  /// Log a debug message.
  static void debug(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.fine(message, error, stackTrace);
  }

  /// Log an error message.
  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.severe(message, error, stackTrace);
  }

  /// Log a fine-grained debug message.
  static void fine(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.fine(message, error, stackTrace);
  }

  /// Log an informational message.
  static void info(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.info(message, error, stackTrace);
  }

  /// Initialize the global logger with app-specific configuration.
  static void initialize({Level defaultLevel = Level.ALL}) {
    if (_isInitialized) return;

    // Set root logger level
    Logger.root.level = defaultLevel;

    // Configure the root logger handler
    Logger.root.onRecord.listen((record) {
      final levelName = record.level.name;
      final message = record.message;
      final timestamp = record.time.toIso8601String();

      // Log to console via debugPrint (works in debug and release)
      final logMessage = '[$timestamp] $levelName: $message';
      debugPrint(logMessage);
    });

    _isInitialized = true;
  }

  /// Log an exception with automatic stack trace handling.
  static void logException(
    String context,
    Object exception, [
    StackTrace? stackTrace,
  ]) {
    _logger.severe(
      'Exception in $context: $exception',
      exception,
      stackTrace ?? StackTrace.current,
    );
  }

  /// Log a warning message.
  static void warning(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.warning(message, error, stackTrace);
  }
}

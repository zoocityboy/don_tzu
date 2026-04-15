import 'package:flutter/material.dart';
import 'package:art_of_deal_war/core/services/app_logger.dart';

/// Enum representing different types of errors that can occur in the app.
enum AppErrorType {
  network,
  server,
  cache,
  permission,
  unknown,
}

/// Class representing an app error with type and user-friendly message.
class AppError {
  final AppErrorType type;
  final String message;
  final String? originalError;
  final StackTrace? stackTrace;

  const AppError({
    required this.type,
    required this.message,
    this.originalError,
    this.stackTrace,
  });

  /// Create AppError from any exception.
  factory AppError.fromException(Object error, [StackTrace? stackTrace]) {
    final errorString = error.toString().toLowerCase();

    // Network errors
    if (errorString.contains('socketexception') ||
        errorString.contains('timeout') ||
        errorString.contains('connection') ||
        errorString.contains('network')) {
      return AppError(
        type: AppErrorType.network,
        message: 'network_error',
        originalError: error.toString(),
        stackTrace: stackTrace,
      );
    }

    // Server/API errors
    if (errorString.contains('server') ||
        errorString.contains('http') ||
        errorString.contains('api') ||
        errorString.contains('500') ||
        errorString.contains('503')) {
      return AppError(
        type: AppErrorType.server,
        message: 'server_error',
        originalError: error.toString(),
        stackTrace: stackTrace,
      );
    }

    // Cache/Storage errors
    if (errorString.contains('cache') ||
        errorString.contains('storage') ||
        errorString.contains('hive') ||
        errorString.contains('database') ||
        errorString.contains('sqlite')) {
      return AppError(
        type: AppErrorType.cache,
        message: 'cache_error',
        originalError: error.toString(),
        stackTrace: stackTrace,
      );
    }

    // Permission errors
    if (errorString.contains('permission') ||
        errorString.contains('denied') ||
        errorString.contains('unauthorized') ||
        errorString.contains('forbidden')) {
      return AppError(
        type: AppErrorType.permission,
        message: 'permission_error',
        originalError: error.toString(),
        stackTrace: stackTrace,
      );
    }

    // Unknown error
    return AppError(
      type: AppErrorType.unknown,
      message: 'unknown_error',
      originalError: error.toString(),
      stackTrace: stackTrace,
    );
  }
}

/// Service to handle and display errors to the user.
class ErrorService {
  static final ErrorService _instance = ErrorService._();
  static ErrorService get instance => _instance;

  ErrorService._();

  /// Show error snackbar to the user based on error type.
  void showError(BuildContext context, AppError error) {
    final message = _getLocalizedMessage(context, error.type);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              _getIconForType(error.type),
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: _getColorForType(error.type),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );

    // Log the error
    AppLogger.error(
      'AppError: ${error.type.name} - ${error.message}',
      error.originalError,
    );
  }

  /// Show a simple error message.
  void showSimpleError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  /// Show success message.
  void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  String _getLocalizedMessage(BuildContext context, AppErrorType type) {
    // Simple fallback messages - in production, use proper localization
    switch (type) {
      case AppErrorType.network:
        return 'Network error. Please check your connection.';
      case AppErrorType.server:
        return 'Server error. Please try again later.';
      case AppErrorType.cache:
        return 'Storage error. Please restart the app.';
      case AppErrorType.permission:
        return 'Permission denied. Please check your permissions.';
      case AppErrorType.unknown:
        return 'Something went wrong. Please try again.';
    }
  }

  IconData _getIconForType(AppErrorType type) {
    switch (type) {
      case AppErrorType.network:
        return Icons.wifi_off;
      case AppErrorType.server:
        return Icons.cloud_off;
      case AppErrorType.cache:
        return Icons.storage;
      case AppErrorType.permission:
        return Icons.lock_outline;
      case AppErrorType.unknown:
        return Icons.error_outline;
    }
  }

  Color _getColorForType(AppErrorType type) {
    switch (type) {
      case AppErrorType.network:
        return Colors.orange.shade700;
      case AppErrorType.server:
        return Colors.purple.shade700;
      case AppErrorType.cache:
        return Colors.amber.shade700;
      case AppErrorType.permission:
        return Colors.red.shade700;
      case AppErrorType.unknown:
        return Colors.red.shade700;
    }
  }
}

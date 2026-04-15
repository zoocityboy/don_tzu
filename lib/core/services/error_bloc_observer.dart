import 'package:art_of_deal_war/core/services/app_logger.dart';
import 'package:art_of_deal_war/core/services/error_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Custom BlocObserver that catches errors from all BLoCs and logs them.
class AppBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    AppLogger.debug('Bloc event: ${bloc.runtimeType} - $event');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    AppLogger.debug(
      'Bloc state change: ${change.currentState} -> ${change.nextState} in ${bloc.runtimeType}',
    );
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);

    // Log the error
    AppLogger.logException(
      '${bloc.runtimeType}',
      error,
      stackTrace,
    );

    // Store error for display
    final appError = AppError.fromException(error, stackTrace);
    _lastError = appError;
  }

  static AppError? _lastError;

  /// Get the last error that occurred.
  static AppError? get lastError => _lastError;

  /// Clear the last error.
  static void clearLastError() {
    _lastError = null;
  }
}

/// Extension on BuildContext to show errors easily.
extension ErrorExtension on BuildContext {
  /// Show an error from an exception.
  void showErrorFromException(Object error, [StackTrace? stackTrace]) {
    final appError = AppError.fromException(error, stackTrace);
    ErrorService.instance.showError(this, appError);
  }

  /// Show a simple error message.
  void showErrorMessage(String message) {
    ErrorService.instance.showSimpleError(this, message);
  }

  /// Show a success message.
  void showSuccessMessage(String message) {
    ErrorService.instance.showSuccess(this, message);
  }
}

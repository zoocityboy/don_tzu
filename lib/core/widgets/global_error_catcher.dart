import 'package:flutter/material.dart';
import 'package:art_of_deal_war/core/services/error_service.dart';

/// A widget that wraps its child and provides error handling methods.
/// Use the ErrorHandler.of(context) to show errors from anywhere in the widget tree.
class ErrorHandler extends InheritedWidget {
  const ErrorHandler({
    super.key,
    required super.child,
  });

  /// Show an error from an exception.
  static void showError(
    BuildContext context,
    Object error, [
    StackTrace? stackTrace,
  ]) {
    final appError = AppError.fromException(error, stackTrace);
    ErrorService.instance.showError(context, appError);
  }

  /// Show a simple error message.
  static void showErrorMessage(BuildContext context, String message) {
    ErrorService.instance.showSimpleError(context, message);
  }

  /// Show a success message.
  static void showSuccessMessage(BuildContext context, String message) {
    ErrorService.instance.showSuccess(context, message);
  }

  static ErrorHandler? of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<ErrorHandler>();
    return result;
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}

/// Extension to make it easy to show errors from any BuildContext.
extension ErrorContextExtension on BuildContext {
  /// Show an error from an exception.
  void showError(Object error, [StackTrace? stackTrace]) {
    ErrorHandler.showError(this, error, stackTrace);
  }

  /// Show a simple error message.
  void showErrorMessage(String message) {
    ErrorHandler.showErrorMessage(this, message);
  }

  /// Show a success message.
  void showSuccessMessage(String message) {
    ErrorHandler.showSuccessMessage(this, message);
  }
}

import 'package:musique/imports.dart';

/// A global error handler for service errors.
void Function(Object e, StackTrace stackTrace)? serviceErrorHandler;

T serviceMethodSync<T>(Logger logger, T Function() call) {
  return logger.wrap(() {
    try {
      return call();
    } catch (e, stackTrace) {
      serviceErrorHandler?.call(e, stackTrace);
      rethrow;
    }
  }, level: 2);
}

Future<T> serviceMethodAsync<T>(Logger logger, Future<T> Function() call) async {
  return logger.wrapAsync(() async {
    try {
      return await call();
    } catch (e, stackTrace) {
      serviceErrorHandler?.call(e, stackTrace);
      rethrow;
    }
  }, level: 2);
}

import 'package:flutter/widgets.dart';
import 'package:musique/imports.dart';

abstract class Service with Disposable {
  Service({required this.logger});

  final Logger logger;

  @mustCallSuper
  Future<void> initialize() async {
    await Future.microtask(() => di.signalReady(this));
  }

  Future<T> method<T>(Future<T> Function() fn) => serviceMethodAsync(logger, fn);
  T methodSync<T>(T Function() fn) => serviceMethodSync(logger, fn);
}

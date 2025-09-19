import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:musique/imports.dart';

class Debouncer {
  Debouncer({
    required this.callback,
    this.delay = const Duration(seconds: 1),
  });

  final VoidCallback callback;
  final Duration delay;

  Timer? _timer;

  void schedule() {
    if (_timer != null) _timer!.cancel();
    _timer = Timer(delay, callback);
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}

extension DebouncerDisposableExt on Disposable {
  /// Creates a [Debouncer] that is automatically disposed of when this object is disposed.
  Debouncer $debouncer(
    VoidCallback callback, {
    Duration delay = const Duration(seconds: 1),
  }) {
    final debouncer = Debouncer(callback: callback, delay: delay);
    addDisposeCallback(debouncer.dispose);
    return debouncer;
  }
}

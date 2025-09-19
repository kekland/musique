import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:signals_flutter/signals_flutter.dart' as signals;

/// A mixin that automates the disposal of various objects.
///
/// Use extensions to add additional disposable types as needed. Methods that produce disposable objects should be
/// prefixed with `$`.
mixin Disposable {
  /// Whether this object has been disposed.
  bool get isDisposed => _isDisposed;
  bool _isDisposed = false;

  final _disposeCallbacks = <VoidCallback>{};

  void addDisposeCallback(VoidCallback callback) {
    _disposeCallbacks.add(callback);
  }

  @mustCallSuper
  void dispose() {
    if (_isDisposed) throw StateError('Already disposed');

    for (final disposeCallback in _disposeCallbacks) disposeCallback();
    _disposeCallbacks.clear();

    _isDisposed = true;
  }
}

extension DisposableDisposableExt on Disposable {
  /// Creates a [Disposable] that is automatically disposed of when this object is disposed.
  T $disposable<T extends Disposable>(T disposable) {
    addDisposeCallback(disposable.dispose);
    return disposable;
  }
}

extension HttpDisposableExt on Disposable {
  /// Creates an [http.Client] that is automatically closed when this object is disposed.
  http.Client $httpClient() {
    final client = http.Client();
    addDisposeCallback(client.close);
    return client;
  }
}

extension StreamDisposableExt on Disposable {
  /// Adds a [StreamSubscription] to be automatically cancelled when this object is disposed.
  void $streamListen<T>(
    Stream<T> stream,
    void Function(T) onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    final subscription = stream.listen(onData, onError: onError, onDone: onDone, cancelOnError: cancelOnError);
    addDisposeCallback(subscription.cancel);
  }
}

extension SignalDisposableExt on Disposable {
  /// Creates a [signals.Signal] that is automatically disposed of when this object is disposed.
  signals.FlutterSignal<T> $signal<T>(T initialValue) {
    final signal = signals.signal<T>(initialValue);
    addDisposeCallback(signal.dispose);
    return signal;
  }

  /// Creates a [signals.Effect] that is automatically disposed of when this object is disposed.
  void $effect(void Function() effect) {
    final dispose = signals.effect(effect);
    addDisposeCallback(dispose);
  }

  /// Creates a [signals.Computed] that is automatically disposed of when this object is disposed.
  signals.FlutterComputed<T> $computed<T>(T Function() compute) {
    final computed = signals.computed<T>(compute);
    addDisposeCallback(computed.dispose);
    return computed;
  }

  /// Creates a [signals.ListSignal] that is automatically disposed of when this object is disposed.
  signals.ListSignal<T> $listSignal<T>(List<T> initialValue) {
    final listSignal = signals.listSignal<T>(initialValue);
    addDisposeCallback(listSignal.dispose);
    return listSignal;
  }
}

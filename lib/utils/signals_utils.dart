import 'package:signals_hooks/signals_hooks.dart';

T useSignalValue<T>(T Function() getter) {
  return useComputed(getter).value;
}

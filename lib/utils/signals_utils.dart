import 'package:musique/imports.dart';
import 'package:signals_hooks/signals_hooks.dart';

T useSignalValue<T>(T Function() getter) {
  return useComputed(getter).value;
}

T useDisposable<T extends Disposable>(T Function() create) {
  final disposable = useMemoized(create);

  useEffect(() {
    return disposable.dispose;
  }, [disposable]);

  return disposable;
}

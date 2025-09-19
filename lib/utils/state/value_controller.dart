import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:musique/imports.dart';

abstract class ValueController<T> with Disposable {
  ValueController({required this.logger}) {
    initialize();
  }

  final Logger logger;

  late final isInitialStateSignal = $signal<bool>(true);
  late final valueSignal = $signal<T?>(null);
  late final isLoadingSignal = $signal<bool>(false);
  late final errorSignal = $signal<(Object, StackTrace)?>(null);

  T? get value => valueSignal.value;
  bool get isInitialState => isInitialStateSignal.value;
  bool get isLoading => isLoadingSignal.value;
  Object? get error => errorSignal.value?.$1;
  StackTrace? get errorStackTrace => errorSignal.value?.$2;

  Future<void> load();
  Future<void> refresh();

  void initialize() {}

  void reset() {
    isInitialStateSignal.value = true;
    valueSignal.value = null;
    isLoadingSignal.value = false;
    errorSignal.value = null;
  }
}

abstract class ListValueController<T> extends ValueController<List<T>> {
  ListValueController({required super.logger});

  late final _itemCount = $computed<int>(() => valueSignal.value?.length ?? 0);

  int get itemCount => _itemCount.value;
  bool get isEmpty => _itemCount.value == 0;
  bool get isNotEmpty => _itemCount.value > 0;

  T? operator [](int index) {
    if (index < 0 || index >= _itemCount.value) {
      throw RangeError.range(index, 0, _itemCount.value - 1, 'index', 'Index out of range');
    }

    return valueSignal.value?[index];
  }

  void add(T item) {
    valueSignal.value = [...?valueSignal.value, item];
  }
}

mixin SingleSource<T> on ValueController<T> {
  @protected
  Future<T?> performLoad();

  bool _isRefreshing = false;

  @override
  Future<void> refresh() async {
    if (isLoading || _isRefreshing) return;

    _isRefreshing = true;
    isInitialStateSignal.value = false;

    try {
      final result = await performLoad();
      valueSignal.value = result;
      errorSignal.value = null;
    } catch (e, stackTrace) {
      errorSignal.value = (e, stackTrace);
      // TODO: Show error toast
    } finally {
      _isRefreshing = false;
    }
  }

  @override
  Future<void> load() async {
    if (isLoading || _isRefreshing) return;

    isLoadingSignal.value = true;
    isInitialStateSignal.value = false;
    errorSignal.value = null;

    try {
      final result = await performLoad();
      valueSignal.value = result;
    } catch (e, stackTrace) {
      errorSignal.value = (e, stackTrace);
    } finally {
      isLoadingSignal.value = false;
    }
  }
}

mixin PaginatedSource<T, P> on ListValueController<T> {
  late final _paginationKey = $signal<P?>(null);
  late final hasMoreSignal = $computed<bool>(() => valueSignal.value == null || _paginationKey.value != null);

  bool get hasMore => hasMoreSignal.value;

  Future<(List<T> items, P? nextPageToken)> performLoad(P? token);

  var _isRefreshing = false;

  @override
  Future<void> refresh() async {
    if (isLoading || _isRefreshing) return;

    isInitialStateSignal.value = false;
    _isRefreshing = true;

    try {
      final result = await performLoad(null);
      valueSignal.value = result.$1;
      _paginationKey.value = result.$2;
      errorSignal.value = null;
    } catch (e, stackTrace) {
      errorSignal.value = (e, stackTrace);
      // TODO: Show error toast here or something
    } finally {
      _isRefreshing = false;
    }
  }

  @override
  Future<void> load() async {
    if (isLoading || _isRefreshing) return;
    if (!hasMore) return;

    isLoadingSignal.value = true;
    errorSignal.value = null;
    isInitialStateSignal.value = false;

    try {
      final result = await performLoad(_paginationKey.value);
      valueSignal.value = [...?valueSignal.value, ...result.$1];
      _paginationKey.value = result.$2;
    } catch (e, stackTrace) {
      errorSignal.value = (e, stackTrace);
      // TODO: Show error toast here or something
    } finally {
      isLoadingSignal.value = false;
    }
  }

  @override
  void reset() {
    _paginationKey.value = null;
    super.reset();
  }
}

mixin QueryableSource<T> on ValueController<T> {
  late final _debouncer = $debouncer(load, delay: const Duration(milliseconds: 500));
  late final _query = $signal<String?>(null);
  String get query => _query.value ?? '';
  set query(String value) => _query.value = value;

  bool get providesResultsOnEmptyQuery => true;
  bool _isLoadingOverridden = false;

  @override
  void initialize() {
    super.initialize();

    $effect(() {
      _query.value;
      reset();

      if (query.isNotEmpty || providesResultsOnEmptyQuery) {
        isInitialStateSignal.value = false;
        isLoadingSignal.value = true;
        _isLoadingOverridden = true;
        _debouncer.schedule();
      }
    });
  }

  @override
  Future<void> load() async {
    if (_isLoadingOverridden) {
      isLoadingSignal.value = false;
      _isLoadingOverridden = false;
    }

    if (query.isEmpty && !providesResultsOnEmptyQuery) return;

    return super.load();
  }
}

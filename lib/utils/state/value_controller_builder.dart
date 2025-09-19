import 'package:flutter/widgets.dart';
import 'package:musique/imports.dart';

class ValueControllerBuilder<T> extends HookWidget {
  const ValueControllerBuilder({
    super.key,
    required this.valueController,
    required this.valueBuilder,
    this.initialStateBuilder,
    this.loadingBuilder,
    this.errorBuilder,
    this.emptyBuilder,
    this.defaultWidget = const SizedBox.shrink(),
  });

  final ValueController<T> valueController;
  final WidgetBuilder? initialStateBuilder;
  final Widget Function(BuildContext context, Object? error)? loadingBuilder;
  final Widget Function(BuildContext context, Object error)? errorBuilder;
  final Widget Function(BuildContext context, T value, bool isLoading, Object? error) valueBuilder;
  final Widget Function(BuildContext context)? emptyBuilder;
  final Widget defaultWidget;

  @override
  Widget build(BuildContext context) {
    final isInitialState = useExistingSignal(valueController.isInitialStateSignal).value;
    final value = useExistingSignal(valueController.valueSignal).value;
    final isLoading = useExistingSignal(valueController.isLoadingSignal).value;
    final error = useExistingSignal(valueController.errorSignal).value;

    // Cases are as follows:
    // - Initial state: show [initialStateBuilder]
    // - No value, no loading, no error: show [emptyBuilder]
    // - No value, loading, no error: show [loadingBuilder]
    // - No value, no loading, error: show [errorBuilder]
    // - No value, loading, error: show [loadingBuilder]
    // - Value, no loading, no error: show [valueBuilder]
    // - Value, loading, no error: show [valueBuilder]
    // - Value, no loading, error: show [valueBuilder]
    // - Value, loading, error: show [valueBuilder]

    if (isInitialState) {
      return initialStateBuilder?.call(context) ?? defaultWidget;
    } else {
      if (value == null) {
        if (isLoading) {
          return loadingBuilder?.call(context, error) ?? defaultWidget;
        } else if (error != null) {
          return errorBuilder?.call(context, error) ?? defaultWidget;
        } else {
          return emptyBuilder?.call(context) ?? defaultWidget;
        }
      } else {
        return valueBuilder(context, value, isLoading, error);
      }
    }
  }
}

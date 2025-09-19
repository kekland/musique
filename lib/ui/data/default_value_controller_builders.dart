import 'package:flutter/material.dart';
import 'package:musique/imports.dart';

Widget _errorBuilder(BuildContext context, Object error) {
  return Placeholder();
}

Widget _inlineErrorBuilder(BuildContext context, Object error) {
  return Placeholder();
}

Widget _loadingBuilder(BuildContext context, Object? error) {
  return const Center(
    child: Padding(
      padding: EdgeInsets.all(64.0),
      child: CircularProgressIndicator(),
    ),
  );
}

Widget _emptyBuilder(BuildContext context) {
  return Placeholder();
}

class MuDefaultValueControllerBuilder<T> extends HookWidget {
  const MuDefaultValueControllerBuilder({
    super.key,
    required this.valueController,
    required this.valueBuilder,
    this.initialStateBuilder,
    this.loadingBuilder,
    this.errorBuilder,
    this.emptyBuilder,
    this.padding = EdgeInsets.zero,
  });

  final ValueController<T> valueController;
  final WidgetBuilder? initialStateBuilder;
  final Widget Function(BuildContext context, Object? error)? loadingBuilder;
  final Widget Function(BuildContext context, Object? error)? errorBuilder;
  final Widget Function(BuildContext context, T value) valueBuilder;
  final Widget Function(BuildContext context)? emptyBuilder;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final errorBuilder = this.errorBuilder ?? _errorBuilder;
    final loadingBuilder = this.loadingBuilder ?? _loadingBuilder;
    final emptyBuilder = this.emptyBuilder ?? _emptyBuilder;
    final WidgetBuilder? initialStateBuilder;

    if (this.initialStateBuilder != null) {
      initialStateBuilder = this.initialStateBuilder!;
    } else {
      initialStateBuilder = null;
    }

    return Padding(
      padding: padding,
      child: ValueControllerBuilder(
        valueController: valueController,
        valueBuilder: (context, value, _, __) => valueBuilder(context, value),
        initialStateBuilder: initialStateBuilder,
        loadingBuilder: (context, error) {
          if (error != null) return errorBuilder(context, error);
          return loadingBuilder(context, error);
        },
        errorBuilder: errorBuilder,
        emptyBuilder: emptyBuilder,
      ),
    );
  }
}

class MuDefaultListValueControllerBuilder<T> extends StatelessWidget {
  const MuDefaultListValueControllerBuilder({
    super.key,
    required this.valueController,
    required this.valueBuilder,
    this.separatorBuilder,
    this.initialStateBuilder,
    this.loadingBuilder,
    this.errorBuilder,
    this.emptyBuilder,
    this.padding = EdgeInsets.zero,
  });

  final ListValueController<T> valueController;
  final WidgetBuilder? initialStateBuilder;
  final Widget Function(BuildContext context, Object? error)? loadingBuilder;
  final Widget Function(BuildContext context, Object? error)? errorBuilder;
  final Widget Function(BuildContext context, int index, T value) valueBuilder;
  final Widget Function(BuildContext context, int index)? separatorBuilder;
  final Widget Function(BuildContext context)? emptyBuilder;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final errorBuilder = this.errorBuilder ?? _errorBuilder;
    final loadingBuilder = this.loadingBuilder ?? _loadingBuilder;
    final emptyBuilder = this.emptyBuilder ?? _emptyBuilder;
    final WidgetBuilder? initialStateBuilder;

    if (this.initialStateBuilder != null) {
      initialStateBuilder = this.initialStateBuilder!;
    } else {
      initialStateBuilder = null;
    }

    return SliverPadding(
      padding: padding,
      sliver: ValueControllerBuilder(
        valueController: valueController,
        valueBuilder: (context, value, isLoading, error) {
          if (value.isEmpty) {
            return SliverToBoxAdapter(child: Center(child: emptyBuilder(context)));
          }

          return SliverMainAxisGroup(
            slivers: [
              if (separatorBuilder != null)
                SliverList.separated(
                  itemBuilder: (context, i) => valueBuilder(context, i, value[i]),
                  separatorBuilder: (context, i) => separatorBuilder!(context, i),
                  itemCount: value.length,
                )
              else
                SliverList.builder(
                  itemBuilder: (context, i) => valueBuilder(context, i, value[i]),
                  itemCount: value.length,
                ),
              if (error != null)
                SliverToBoxAdapter(child: _inlineErrorBuilder(context, error))
              else if (isLoading)
                SliverToBoxAdapter(child: SizedBox(height: 64.0, child: loadingBuilder(context, error))),
            ],
          );
        },
        initialStateBuilder: initialStateBuilder,
        loadingBuilder: (context, error) {
          final Widget child;

          if (error != null) {
            child = errorBuilder(context, error);
          } else {
            child = loadingBuilder(context, error);
          }

          return SliverToBoxAdapter(child: Center(child: child));
        },
        errorBuilder: (context, error) {
          return SliverToBoxAdapter(child: Center(child: errorBuilder(context, error)));
        },
        emptyBuilder: (context) {
          return SliverToBoxAdapter(child: Center(child: emptyBuilder(context)));
        },
        defaultWidget: const SliverToBoxAdapter(),
      ),
    );
  }
}

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

class DefaultValueControllerBuilder<T> extends HookWidget {
  const DefaultValueControllerBuilder({
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

class DefaultListValueControllerBuilder<T> extends HookWidget {
  const DefaultListValueControllerBuilder({
    super.key,
    required this.valueController,
    required this.valueBuilder,
    this.separatorBuilder,
    this.initialStateBuilder,
    this.loadingBuilder,
    this.errorBuilder,
    this.emptyBuilder,
    this.itemExtent,
    this.separatorExtent,
    this.padding = EdgeInsets.zero,
  });

  final ListValueController<T> valueController;
  final WidgetBuilder? initialStateBuilder;
  final Widget Function(BuildContext context, Object? error)? loadingBuilder;
  final Widget Function(BuildContext context, Object? error)? errorBuilder;
  final Widget Function(BuildContext context, int index, T value) valueBuilder;
  final Widget Function(BuildContext context, int index)? separatorBuilder;
  final Widget Function(BuildContext context)? emptyBuilder;
  final double? itemExtent;
  final double? separatorExtent;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final errorBuilder = this.errorBuilder ?? _errorBuilder;
    final loadingBuilder = this.loadingBuilder ?? _loadingBuilder;
    final emptyBuilder = this.emptyBuilder ?? _emptyBuilder;
    final WidgetBuilder? initialStateBuilder;

    // Listen to scrollable to update paginated source
    if (valueController is PaginatedSource) {
      final valueController = this.valueController as PaginatedSource;
      final scrollable = Scrollable.of(context);

      useEffect(
        () {
          void listener() {
            final position = scrollable.position;
            if (valueController.hasMore && position.pixels >= position.maxScrollExtent - 200) {
              valueController.load();
            }
          }

          scrollable.position.addListener(listener);
          return () => scrollable.position.removeListener(listener);
        },
        [scrollable],
      );
    }

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

          final T Function(int index) getItem;

          int? itemCount;
          if (valueController is PaginatedSource) {
            final valueController = this.valueController as PaginatedSource;
            itemCount = valueController.totalCount;
            getItem = (i) {
              if (i + 5 >= value.length && valueController.hasMore && !isLoading) {
                // Load more when reaching the end
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  valueController.load();
                });
              }

              return value[i];
            };
          } else {
            getItem = (i) => value[i];
          }

          itemCount ??= value.length;

          Widget itemBuilder(_, int i) {
            // TODO: Shimmer for not loaded items
            if (i >= value.length) return const SizedBox.shrink();

            return valueBuilder(context, i, getItem(i));
          }

          Widget separatorBuilder(_, int i) => this.separatorBuilder!(context, i);

          Widget buildSeparated() {
            if (itemExtent != null && separatorExtent != null) {
              return SliverVariedExtentList(
                delegate: SeparatedSliverChildBuilderDelegate(
                  itemBuilder: itemBuilder,
                  separatorBuilder: separatorBuilder,
                  itemCount: itemCount!,
                ),
                itemExtentBuilder: (int i, _) => i.isEven ? itemExtent! : separatorExtent!,
              );
            }

            return SliverList.separated(
              itemBuilder: itemBuilder,
              separatorBuilder: separatorBuilder,
              itemCount: itemCount!,
            );
          }

          Widget buildRegular() {
            if (itemExtent != null) {
              return SliverFixedExtentList(
                itemExtent: itemExtent!,
                delegate: SliverChildBuilderDelegate(
                  itemBuilder,
                  childCount: itemCount,
                ),
              );
            }

            return SliverList.builder(
              itemBuilder: itemBuilder,
              itemCount: itemCount,
            );
          }

          return SliverMainAxisGroup(
            slivers: [
              if (this.separatorBuilder != null) buildSeparated() else buildRegular(),
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

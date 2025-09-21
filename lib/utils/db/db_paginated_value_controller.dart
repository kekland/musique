import 'package:drift/drift.dart';
import 'package:musique/imports.dart';

abstract class DbPaginatedValueController<TItem, TTbl extends TableInfo> extends ListValueController<TItem>
    with PaginatedSource<TItem, int> {
  DbPaginatedValueController({
    required super.logger,
    this.where,
    this.orderBy,
    this.pageSize = 50,
  });

  final Expression<bool> Function(TTbl)? where;
  final List<OrderingTerm Function(TTbl)>? orderBy;
  final int pageSize;

  TTbl get table;

  @override
  Future<(List<TItem>, int?, int?)> performLoad(int? token) async {
    final countQuery = table.count(where: where as dynamic);
    final count = await countQuery.getSingle();

    final query = table.select();
    if (where != null) query.where(where! as dynamic);
    if (orderBy != null) query.orderBy(orderBy! as dynamic);
    query.limit(pageSize, offset: token);

    final items = await query.get();
    final nextPageToken = items.length < pageSize ? null : (token ?? 0) + items.length;
    return (items.cast<TItem>(), nextPageToken, count);
  }
}

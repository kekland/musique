import 'package:drift/drift.dart';
import 'package:musique/imports.dart';

abstract class AlbumsValueController extends DbPaginatedValueController<Album, $AlbumsTable> {
  AlbumsValueController({
    required super.logger,
    super.where,
    super.orderBy,
    super.pageSize,
  });

  @override
  $AlbumsTable get table => di.db.albums;
}

class AllAlbumsValueController extends AlbumsValueController {
  AllAlbumsValueController() : super(logger: log.app.child('AllAlbumsValueController'));
}

class AlbumValueController extends ValueController<Album> with SingleSource {
  AlbumValueController({required this.id}) : super(logger: log.app.child('AlbumValueController'));

  final int id;

  @override
  Future<Album?> performLoad() {
    return (di.db.albums.select()..where((t) => t.id.equals(id))).getSingle();
  }
}

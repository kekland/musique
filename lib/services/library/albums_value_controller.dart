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

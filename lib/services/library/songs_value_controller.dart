import 'package:drift/drift.dart';
import 'package:musique/imports.dart';

abstract class SongsValueController extends DbPaginatedValueController<Song, $SongsTable> {
  SongsValueController({
    required super.logger,
    super.where,
    super.orderBy,
    super.pageSize,
  });

  @override
  $SongsTable get table => di.db.songs;
}

class AllSongsValueController extends SongsValueController {
  AllSongsValueController() : super(logger: log.app.child('AllSongsValueController'));
}

class AlbumSongsValueController extends SongsValueController {
  AlbumSongsValueController({required this.albumId})
    : super(
        logger: log.app.child('AlbumSongsValueController/$albumId'),
        where: (t) => t.albumId.equals(albumId),
        orderBy: [(t) => OrderingTerm.asc(t.discNumber), (t) => OrderingTerm.asc(t.trackNumber)],
      );

  final int albumId;
}

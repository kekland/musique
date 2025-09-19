import 'package:drift/drift.dart';
import 'package:musique/imports.dart';
import 'package:musique/utils/state/service.dart';

class MusicLibraryService extends Service {
  MusicLibraryService() : super(logger: log.app.child('MusicLibraryService'));

  final allSongsController = AllSongsValueController();

  @override
  Future<void> initialize() async {
    await allSongsController.load();
    return super.initialize();
  }
}

class AllSongsValueController extends ListValueController<Song> with SingleSource {
  AllSongsValueController() : super(logger: log.app.child('AllSongsValueController'));

  @override
  Future<List<Song>?> performLoad() {
    return di.db.songs.select().get();
  }
}

import 'package:musique/imports.dart';
import 'package:musique/services/library/albums_value_controller.dart';
import 'package:musique/services/library/songs_value_controller.dart';

class MusicLibraryService extends Service {
  MusicLibraryService() : super(logger: log.app.child('MusicLibraryService'));

  final allSongsController = AllSongsValueController();
  final allAlbumsController = AllAlbumsValueController();

  @override
  Future<void> initialize() async {
    await allSongsController.load();
    await allAlbumsController.load();

    return super.initialize();
  }
}

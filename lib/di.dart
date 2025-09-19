import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:musique/imports.dart';
import 'package:musique/services/music_library_service.dart';
import 'package:musique/services/player/music_player_service.dart';

final di = GetIt.instance;

/// Extensions on [GetIt] to provide easy access to various services and configurations.
extension GetItExtensions on GetIt {
  MusiqueDatabase get db => get<MusiqueDatabase>();
  MusicLibraryService get library => get<MusicLibraryService>();
  MusicPlayerService get player => get<MusicPlayerService>();
}

Future<void> setupDi(Directory libraryDirectory) async {
  return log.app.wrapAsync(() async {
    di.registerSingleton(MusiqueDatabase.fromDirectory(libraryDirectory: libraryDirectory));

    Future<void> registerService<T extends Service>(T service) {
      di.registerSingleton<T>(service, signalsReady: true);
      return service.initialize();
    }

    await [
      registerService(MusicLibraryService()),
      registerService(MusicPlayerService()),
    ].wait;

    await di.allReady();
  });
}

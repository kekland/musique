import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart' as logging;
import 'package:musique/app/app.dart';
import 'package:musique/data/sync.dart';
import 'package:musique/imports.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  final libraryDirectory = Directory('/Users/kekland/Desktop/Music');
  SignalsObserver.instance = LoggerSignalsObserver();
  Logger.root.level = kDebugMode ? logging.Level.ALL : logging.Level.INFO;
  Logger.root.onRecord.listen(logColorized);

  await setupDi(libraryDirectory);
  await syncDatabase(libraryDirectory, db: di.db);

  runApp(MusiqueApp());
}

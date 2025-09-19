import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'db.g.dart';

class Pictures extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get hash => integer()();
  BlobColumn get data => blob()();
}

class Artists extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get pictureId => integer().nullable().references(Pictures, #id)();
}

class Albums extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get year => integer().nullable()();

  IntColumn get artistId => integer().nullable().references(Artists, #id)();
  TextColumn get artist => text().nullable()();
  IntColumn get pictureId => integer().nullable().references(Pictures, #id)();
}

class Songs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get filePath => text()();
  BoolColumn get isValid => boolean()();
  TextColumn get title => text()();
  TextColumn get performers => text().nullable()();
  IntColumn get durationMs => integer().nullable()();
  IntColumn get trackNumber => integer().nullable()();
  IntColumn get discNumber => integer().nullable()();
  IntColumn get year => integer().nullable()();

  IntColumn get artistId => integer().nullable().references(Artists, #id)();
  TextColumn get artist => text().nullable()();
  IntColumn get albumId => integer().nullable().references(Albums, #id)();
  TextColumn get album => text().nullable()();
  IntColumn get pictureId => integer().nullable().references(Pictures, #id)();
}

@DriftDatabase(tables: [Pictures, Artists, Albums, Songs])
class MusiqueDatabase extends _$MusiqueDatabase {
  MusiqueDatabase.fromQueryExecutor(super.executor);
  MusiqueDatabase.fromDirectory({required Directory libraryDirectory}) : super(_openConnection(libraryDirectory));

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection(Directory libraryDirectory) {
    return driftDatabase(
      name: 'musique_db',
      native: DriftNativeOptions(
        databasePath: () async => '${libraryDirectory.path}/musique.sqlite',
      ),
    );
  }
}

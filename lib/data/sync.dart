import 'dart:io';

import 'package:drift/drift.dart';
import 'package:musique/data/db/db.dart';
import 'package:musique/data/parser.dart';

Future<void> syncDatabase(Directory libraryDirectory, {MusiqueDatabase? db}) async {
  final _db = db ?? MusiqueDatabase.fromDirectory(libraryDirectory: libraryDirectory);

  // Mark all songs as invalid initially
  await _db.songs.update().write(SongsCompanion(isValid: Value(false)));

  await for (final parsedSong in parseLibrary(libraryDirectory)) {
    // Check if the song already exists in the database
    final results = await (_db.songs.select()..where((t) => t.filePath.equals(parsedSong.file.path))).get();
    final exists = results.isNotEmpty;

    // If there is more than one result, we have a problem. Remove duplicates.
    if (results.length > 1) {
      final idsToDelete = results.skip(1).map((e) => e.id).toList();
      await (_db.songs.delete()..where((t) => t.id.isIn(idsToDelete))).go();
    }

    // Check for the existence of the picture
    int? pictureId;
    if (parsedSong.picture != null) {
      final query = _db.pictures.select()..where((t) => t.hash.equals(parsedSong.picture!.hash));
      final pictureResults = await query.get();

      if (pictureResults.isNotEmpty) {
        pictureId = pictureResults.first.id;
      } else {
        final pictureCompanion = PicturesCompanion(
          hash: Value(parsedSong.picture!.hash),
          data: Value(parsedSong.picture!.data),
        );

        pictureId = await _db.into(_db.pictures).insert(pictureCompanion);
      }
    }

    // Check for the existence of the artist
    int? artistId;
    if (parsedSong.artist != null) {
      final query = _db.artists.select()..where((t) => t.name.equals(parsedSong.artist!));
      final artistResults = await query.get();

      final companion = ArtistsCompanion(name: Value(parsedSong.artist!));

      if (artistResults.isNotEmpty) {
        final artist = artistResults.first;
        artistId = artist.id;
        await (_db.artists.update()..whereSamePrimaryKey(artist)).write(companion);
      } else {
        artistId = await _db.into(_db.artists).insert(companion);
      }
    }

    // Check for the existence of the album
    int? albumId;
    if (parsedSong.album != null) {
      final query = _db.albums.select()
        ..where((t) => t.name.equals(parsedSong.album!) & t.artistId.isExp(Constant(artistId)));

      final albumResults = await query.get();

      final companion = AlbumsCompanion(
        name: Value(parsedSong.album!),
        artistId: Value(artistId),
        artist: parsedSong.artist != null ? Value(parsedSong.artist) : Value.absent(),
        year: parsedSong.year != null ? Value(parsedSong.year) : Value.absent(),
        pictureId: Value(pictureId),
      );

      if (albumResults.isNotEmpty) {
        final album = albumResults.first;
        albumId = album.id;
        await (_db.albums.update()..whereSamePrimaryKey(album)).write(companion);
      } else {
        albumId = await _db.into(_db.albums).insert(companion);
      }
    }

    // Update or insert the song
    final songCompanion = SongsCompanion(
      id: exists ? Value(results.first.id) : Value.absent(),
      filePath: Value(parsedSong.file.path),
      isValid: Value(true),
      title: Value(parsedSong.title),
      artistId: Value(artistId),
      artist: Value(parsedSong.artist),
      albumId: Value(albumId),
      album: Value(parsedSong.album),
      trackNumber: Value(parsedSong.trackNumber),
      discNumber: Value(parsedSong.discNumber),
      durationMs: Value(parsedSong.duration?.inMilliseconds),
      performers: Value(parsedSong.performers),
      year: Value(parsedSong.year),
      pictureId: Value(pictureId),
    );

    await _db.into(_db.songs).insertOnConflictUpdate(songCompanion);
  }
}
